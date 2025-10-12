import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nutrition_calender/components/checkitems_page.dart';
import 'package:nutrition_calender/components/data_dummy.dart';

class TodayPage extends StatelessWidget {
  TodayPage({super.key});

  final NutritionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final checkdate = controller.currentDate.value;

    final meals = ['Breakfast', 'Lunch', 'Dinner', 'Other'];

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.currentDate.value)),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final mealName = meals[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              title: Text(mealName),
              trailing: IconButton(
                icon: const Icon(Icons.add, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CheckItemsPage(date: checkdate, time: index),
                    ),
                  );
                },
              ),
              subtitle: Obx(() {
                // Show number of selected items for this meal
                final et = controller.check[checkdate];
                if (et == null) return Text("No selected item(s)");
                final count = _getMealList(et, index).where((i) => i.State).length;
                if (count == 0) return Text("$count selected item(s)");
                return Text("$count selected item(s)");
              }),
            ),
          );
        },
      ),
    );
  }

  // Helper to get meal list from EatingTime
  List<Item> _getMealList(EatingTime et, int time) {
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
