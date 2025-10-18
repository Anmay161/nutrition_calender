import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_calender/components/data_dummy.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  final NutritionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Obx(() {
        final entries = controller.check.entries.toList();
        if (entries.isEmpty) {
          return const Center(
            child: Text(
              "No history available.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final dateStr = entry.key;
            final eatingTime = entry.value;

            final formattedDate = DateFormat(
              'EEE, dd MMM yyyy',
            ).format(DateTime.parse(dateStr));

            // Group selected items by meal
            final Map<String, List<Item>> selectedMeals = {
              "Breakfast":
                  eatingTime.breakfast.where((item) => item.State).toList(),
              "Lunch": eatingTime.lunch.where((item) => item.State).toList(),
              "Dinner": eatingTime.dinner.where((item) => item.State).toList(),
              "Other": eatingTime.other.where((item) => item.State).toList(),
            };

            final totalSelected = selectedMeals.values.fold<int>(
              0,
              (sum, list) => sum + list.length,
            );

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.history, color: Colors.blueAccent),
                title: Text(
                  formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$totalSelected item(s) logged",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                children:
                    selectedMeals.entries.where((e) => e.value.isNotEmpty).map((
                      e,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...e.value.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  "- ${item.Name} (${item.Amount} g)",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            );
          },
        );
      }),
    );
  }
}
