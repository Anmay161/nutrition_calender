import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_dummy.dart'; // your GetX controller

class CheckItemsPage extends StatelessWidget {
  final String date;
  final int time; // 0 = breakfast, 1 = lunch, 2 = dinner, 3 = other

  CheckItemsPage({super.key, required this.date, required this.time});

  final NutritionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final RxList<Item> itemsForMeal = _getMealList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Food Items'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        final selectedItems = itemsForMeal.where((item) => item.State).toList();

        if (selectedItems.isEmpty) {
          return const Center(
            child: Text(
              "No selected items.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: selectedItems.length,
          itemBuilder: (context, index) {
            final item = selectedItems[index];
            final controllerAmount = TextEditingController(text: item.Amount.toString());

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Obx(() => Checkbox(
                      value: item.State,
                      onChanged: (val) {
                        if (val != null) {
                          controller.toggleItemState(item, val);
                        }
                      },
                    )),
                title: Obx(() => Text(item.Name)),
                trailing: SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controllerAmount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      suffixText: 'g',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                    onChanged: (val) {
                      final amount = double.tryParse(val);
                      if (amount != null && amount > 0) {
                        controller.updateItemAmount(item, amount);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Helper to get the RxList<Item> for the current meal
  RxList<Item> _getMealList() {
    final et = controller.check[date];
    if (et == null) return <Item>[].obs;

    switch (time) {
      case 0:
        return et.breakfast;
      case 1:
        return et.lunch;
      case 2:
        return et.dinner;
      default:
        return et.other;
    }
  }
}
