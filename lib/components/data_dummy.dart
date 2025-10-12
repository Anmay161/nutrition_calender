import 'package:get/get.dart';

// --- Reactive models ---

class Item {
  final RxString name;
  final RxBool state;
  final RxDouble amount;

  Item(String name, bool state, {double amount = 100})
    : name = name.obs,
      state = state.obs,
      amount = amount.obs;

  // convenience getters/setters
  String get Name => name.value;
  set Name(String v) => name.value = v;

  bool get State => state.value;
  set State(bool v) => state.value = v;

  double get Amount => amount.value;
  set Amount(double v) => amount.value = v;
}

class EatingTime {
  // Reactive lists
  final RxList<Item> breakfast = <Item>[].obs;
  final RxList<Item> lunch = <Item>[].obs;
  final RxList<Item> dinner = <Item>[].obs;
  final RxList<Item> other = <Item>[].obs;

  // helper to check emptiness
  bool get isEmpty =>
      breakfast.isEmpty && lunch.isEmpty && dinner.isEmpty && other.isEmpty;
}
// --- Controller ---

class NutritionController extends GetxController {
  // reactive map: date -> EatingTime
  final RxMap<String, EatingTime> check = <String, EatingTime>{}.obs;

  // optional: current date
  RxString currentDate = DateTime.now().toString().split(' ').first.obs;

  // ensure an EatingTime exists for date
  EatingTime getOrCreateEatingTime(String date) {
    return check.putIfAbsent(date, () => EatingTime());
  }

  // add item to a meal
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
    // no check.refresh() needed; RxList notifies automatically
  }

  // toggle state of an item (reactive field)
  void toggleItemState(Item item, bool value) {
    item.State = value; // item.state.value = value; triggers observers
  }

  // update amount
  void updateItemAmount(Item item, double amount) {
    item.Amount = amount; // item.amount.value = amount;
  }

  // get selected items for a date
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

  // filter and remove non-selected items (in-place)
  void keepOnlySelected(String date) {
    final et = check[date];
    if (et == null) return;
    et.breakfast.retainWhere((i) => i.State);
    et.lunch.retainWhere((i) => i.State);
    et.dinner.retainWhere((i) => i.State);
    et.other.retainWhere((i) => i.State);
    if (et.isEmpty) check.remove(date); // modifies RxMap -> observers triggered
  }
}
