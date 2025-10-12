import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'nutrition_models.dart';

class Item {
  final RxString name;
  final RxBool state;
  final RxDouble amount;

  Item(String name, bool state, {double amount = 100})
    : name = name.obs,
      state = state.obs,
      amount = amount.obs;

  String get Name => name.value;
  set Name(String v) => name.value = v;

  bool get State => state.value;
  set State(bool v) => state.value = v;

  double get Amount => amount.value;
  set Amount(double v) => amount.value = v;
}

class EatingTime {
  final RxList<Item> breakfast = <Item>[].obs;
  final RxList<Item> lunch = <Item>[].obs;
  final RxList<Item> dinner = <Item>[].obs;
  final RxList<Item> other = <Item>[].obs;

  bool get isEmpty =>
      breakfast.isEmpty && lunch.isEmpty && dinner.isEmpty && other.isEmpty;
}

class NutritionController extends GetxController {
  final RxMap<String, EatingTime> check = <String, EatingTime>{}.obs;
  final RxString currentDate = DateTime.now().toString().split(' ').first.obs;

  late Box box;

  @override
  void onInit() {
    super.onInit();
    box = Hive.box('nutrition');
    _loadFromHive();

    // Save when the map itself changes
    ever(check, (_) => _saveToHive());

    // Attach listeners to all loaded EatingTime objects
    check.forEach((date, et) => _attachEatingTimeListeners(et, date));
  }

  // --- Conversion methods ---
  ItemData toItemData(Item i) => ItemData(i.Name, i.State, i.Amount);
  Item fromItemData(ItemData d) => Item(d.name, d.state, amount: d.amount);

  EatingTimeData toEatingTimeData(EatingTime e) => EatingTimeData(
    breakfast: e.breakfast.map(toItemData).toList(),
    lunch: e.lunch.map(toItemData).toList(),
    dinner: e.dinner.map(toItemData).toList(),
    other: e.other.map(toItemData).toList(),
  );

  EatingTime fromEatingTimeData(EatingTimeData d) =>
      EatingTime()
        ..breakfast.addAll(d.breakfast.map(fromItemData))
        ..lunch.addAll(d.lunch.map(fromItemData))
        ..dinner.addAll(d.dinner.map(fromItemData))
        ..other.addAll(d.other.map(fromItemData));

  // --- Hive handling ---
  void _loadFromHive() {
    for (var key in box.keys) {
      final etData = box.get(key) as EatingTimeData?;
      if (etData != null) {
        final et = fromEatingTimeData(etData);
        check[key] = et;
        _attachEatingTimeListeners(et, key); // listen to inner changes
      }
    }
  }

  void _saveToHive() {
    for (var entry in check.entries) {
      box.put(entry.key, toEatingTimeData(entry.value));
    }
  }

  // --- Attach listeners to all Rx fields inside EatingTime ---
  void _attachEatingTimeListeners(EatingTime et, String date) {
    void attachToList(RxList<Item> list) {
      // Listen for additions/removals
      list.listen((_) => check[date] = et);

      // Listen for each item field
      for (var item in list) {
        item.name.listen((_) => check[date] = et);
        item.state.listen((_) => check[date] = et);
        item.amount.listen((_) => check[date] = et);
      }

      // Listen for new items added dynamically
      list.listen((items) {
        for (var item in items) {
          item.name.listen((_) => check[date] = et);
          item.state.listen((_) => check[date] = et);
          item.amount.listen((_) => check[date] = et);
        }
      });
    }

    attachToList(et.breakfast);
    attachToList(et.lunch);
    attachToList(et.dinner);
    attachToList(et.other);
  }

  // --- Core actions ---
  EatingTime getOrCreateEatingTime(String date) {
    final et = check.putIfAbsent(date, () {
      final newEt = EatingTime();
      _attachEatingTimeListeners(newEt, date);
      return newEt;
    });
    return et;
  }

  void addItem(String date, int time, Item item) {
    final et = getOrCreateEatingTime(date);
    switch (time) {
      case 0:
        et.breakfast.add(item);
        break;
      case 1:
        et.lunch.add(item);
        break;
      case 2:
        et.dinner.add(item);
        break;
      case 3:
        et.other.add(item);
        break;
    }

    // Attach listeners to newly added item
    item.name.listen((_) => check[date] = et);
    item.state.listen((_) => check[date] = et);
    item.amount.listen((_) => check[date] = et);
  }

  void toggleItemState(Item item, bool value) => item.State = value;

  void updateItemAmount(Item item, double amount) => item.Amount = amount;

  List<Item> getSelectedItems(String date) {
    final et = check[date];
    if (et == null) return [];
    return [
      ...et.breakfast.where((i) => i.State),
      ...et.lunch.where((i) => i.State),
      ...et.dinner.where((i) => i.State),
      ...et.other.where((i) => i.State),
    ];
  }

  void keepOnlySelected(String date) {
    final et = check[date];
    if (et == null) return;
    et.breakfast.retainWhere((i) => i.State);
    et.lunch.retainWhere((i) => i.State);
    et.dinner.retainWhere((i) => i.State);
    et.other.retainWhere((i) => i.State);
    if (et.isEmpty) check.remove(date);
  }
}
