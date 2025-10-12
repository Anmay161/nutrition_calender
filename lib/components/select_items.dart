import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_calender/constants/dbhelper.dart';
import 'data_dummy.dart';

class SelectItems extends StatelessWidget {
  final String date;
  final int time; // 0 = breakfast, 1 = lunch, 2 = dinner, 3 = other
  final VoidCallback onUpdate;

  SelectItems({
    super.key,
    required this.date,
    required this.time,
    required this.onUpdate,
  });

  final NutritionController nutritionController = Get.find();

  @override
  Widget build(BuildContext context) {
    // get the RxList<Item> for this meal
    final RxList<Item> items = _getMealList();

    // reactive loading indicator
    final loading = true.obs;

    // load items if empty
    if (items.isEmpty) {
      _loadItems(items, loading);
    } else {
      loading.value = false;
    }

    return Obx(() {
      if (loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (items.isEmpty) {
        return Center(
          child: Text(
            "No items added for this meal.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final controller = TextEditingController(
            text: item.Amount.toString(),
          );

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Obx(
                () => Checkbox(
                  value: item.State,
                  onChanged: (val) {
                    item.State = val ?? false; // reactive update
                    onUpdate();
                  },
                ),
              ),
              title: Obx(() => Text(item.Name)),
              trailing: SizedBox(
                width: 80,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    suffixText: 'g',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                  ),
                  onChanged: (val) {
                    double? amount = double.tryParse(val);
                    if (amount != null && amount > 0) {
                      item.Amount = amount; // reactive update
                      onUpdate();
                    }
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // helper to get the RxList<Item> for the meal
  RxList<Item> _getMealList() {
    final et = nutritionController.getOrCreateEatingTime(date);
    switch (time) {
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

  // load items from database if meal list is empty
  Future<void> _loadItems(RxList<Item> items, RxBool loading) async {
    final rows = await DatabaseHelper().getAllItems();

    final loadedItems =
        rows.map((row) {
          String name = row['Food name in English']?.toString().trim() ?? '';
          if (name.isEmpty) {
            name = row['Food name in Bengali']?.toString().trim() ?? 'Unknown';
          }
          return Item(name, false);
        }).toList();

    items.addAll(loadedItems); // reactive
    loading.value = false;
  }
}
