import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // your GetX controller
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

            // format date nicely
            final formattedDate = DateFormat('EEE, dd MMM yyyy')
                .format(DateTime.parse(dateStr));

            // count total items selected that day
            final totalSelected = [
              ...eatingTime.breakfast,
              ...eatingTime.lunch,
              ...eatingTime.dinner,
              ...eatingTime.other
            ].where((item) => item.State).length;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.blueAccent),
                title: Text(
                  formattedDate,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "$totalSelected item(s) logged",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Optionally navigate to detailed view for that date
                  // e.g., Get.to(() => HistoryDetailPage(date: dateStr));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
