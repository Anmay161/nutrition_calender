import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_calender/constants/dbhelper.dart';
import 'data_dummy.dart';

class SelectItems extends StatefulWidget {
  final String date;
  final int time; // 0 = breakfast, 1 = lunch, 2 = dinner, 3 = other
  final VoidCallback onUpdate;

  const SelectItems({
    super.key,
    required this.date,
    required this.time,
    required this.onUpdate,
  });

  @override
  State<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  final NutritionController nutritionController = Get.find();

  late RxList<Item> items;
  final RxBool loading = true.obs;
  final RxString searchQuery = ''.obs;

  // Keep controllers stable
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    items = _getMealList();

    if (items.isEmpty) {
      _loadItems();
    } else {
      loading.value = false;
    }
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar does NOT need Obx
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (val) => searchQuery.value = val,
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
          ),
        ),
        // Reactive list
        Expanded(
          child: Obx(() {
            if (loading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // Filter items by search query
            final filteredItems = searchQuery.value.isEmpty
                ? items
                : items
                    .where((item) => item.Name
                        .toLowerCase()
                        .contains(searchQuery.value.toLowerCase()))
                    .toList();

            if (filteredItems.isEmpty) {
              return Center(
                child: Text(
                  "No items found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];

                // Initialize controller once
                controllers.putIfAbsent(
                    item.Name,
                    () =>
                        TextEditingController(text: item.Amount.toString()));

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Obx(
                      () => Checkbox(
                        value: item.State,
                        onChanged: (val) {
                          item.State = val ?? false;
                          widget.onUpdate();
                        },
                      ),
                    ),
                    title: Obx(() => Text(item.Name)),
                    trailing: SizedBox(
                      width: 80,
                      child: TextField(
                        controller: controllers[item.Name],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          suffixText: 'g',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        ),
                        onChanged: (val) {
                          double? amount = double.tryParse(val);
                          if (amount != null && amount > 0) {
                            item.Amount = amount;
                            widget.onUpdate();
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  RxList<Item> _getMealList() {
    final et = nutritionController.getOrCreateEatingTime(widget.date);
    switch (widget.time) {
      case 0:
        return et.breakfast;
      case 1:
        return et.lunch;
      case 2:
        return et.dinner;
      case 3:
        return et.other;
      default:
        return <Item>[].obs;
    }
  }

  Future<void> _loadItems() async {
    final rows = await DatabaseHelper().getAllItems();
    final loadedItems = rows.map((row) {
      String name = row['Food name in English']?.toString().trim() ?? '';
      if (name.isEmpty) {
        name = row['Food name in Bengali']?.toString().trim() ?? 'Unknown';
      }
      return Item(name, false);
    }).toList();

    items.addAll(loadedItems);
    loading.value = false;
  }
}
