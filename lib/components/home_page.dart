import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as timeline;
import 'package:date_picker_plus/date_picker_plus.dart' as plus;
import 'package:nutrition_calender/components/select_items.dart';
import 'package:nutrition_calender/constants/dbhelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data_dummy.dart'; // Your GetX controller with reactive Item & EatingTime

Future<Map<String, dynamic>?> getUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  return snapshot.data();
}

class NutrientTotals {
  double calories;
  double carbs;
  double proteins;
  double fat;
  double vitaminA;
  double salt;

  NutrientTotals({
    this.calories = 0,
    this.carbs = 0,
    this.proteins = 0,
    this.fat = 0,
    this.vitaminA = 0,
    this.salt = 0,
  });
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final nutritionController = Get.put(NutritionController());

  // reactive nutrient sliders
  final caloriesSlider = 0.0.obs;

  final carbSlider = 0.0.obs;

  final proteinSlider = 0.0.obs;

  final fatSlider = 0.0.obs;

  final vitaminSlider = 0.0.obs;

  final saltSlider = 0.0.obs;

  final nutrientTotals = <String, NutrientTotals>{}.obs;

  // user info
  final userGoal = 'Stay Healthy'.obs;

  final userBMI = 0.0.obs;

  // nutrient targets
  final targetCarbs = 300.0.obs;

  final targetProteins = 150.0.obs;

  final targetFat = 80.0.obs;

  final targetVitamins = 1000.0.obs;

  final targetSalt = 2300.0.obs;

  final targetCalories = 2000.0.obs;

  final selectedDate = DateTime.now().obs;

  final startDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    _initializeData(); // kick off async initialization

    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Obx(() {
          final cleandate = nutritionController.currentDate.value;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Goal: ${userGoal.value} • BMI: ${userBMI.value.toStringAsFixed(1)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              buildNutrientCard(),
              const SizedBox(height: 10),
              buildMealTile("Breakfast", 0, cleandate, context),
              buildMealTile("Lunch", 1, cleandate, context),
              buildMealTile("Dinner", 2, cleandate, context),
              buildMealTile("Other", 3, cleandate, context),
            ],
          );
        }),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => timeline.DatePicker(
                  startDate.value,
                  initialSelectedDate: selectedDate.value,
                  selectionColor: Colors.blueAccent,
                  selectedTextColor: Colors.white,
                  daysCount: 100,
                  dateTextStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  dayTextStyle: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                  monthTextStyle: const TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                  onDateChange: (date) {
                    selectedDate.value = date;
                    final cleandate = date.toString().split(' ').first;
                    nutritionController.currentDate.value = cleandate;
                    _updateNutrients(cleandate);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.blueAccent,
                ),
                onPressed: () async {
                  final picked = await showDialog<DateTime>(
                    context: context,
                    builder:
                        (context) => Dialog(
                          insetPadding: const EdgeInsets.all(16),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.9,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                            ),
                            child: plus.DatePicker(
                              minDate: DateTime(2020, 1, 1),
                              maxDate: DateTime(2030, 12, 31),
                              initialDate: selectedDate.value,
                              onDateSelected: (date) {
                                Navigator.of(context).pop(date);
                              },
                            ),
                          ),
                        ),
                  );

                  if (picked != null) {
                    selectedDate.value = picked;
                    startDate.value = picked;
                    final cleandate = picked.toString().split(' ').first;
                    nutritionController.currentDate.value = cleandate;
                    _updateNutrients(cleandate);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNutrientCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => buildProgressRow(
                Icons.local_fire_department,
                'Calories',
                caloriesSlider.value,
                targetCalories.value,
                Colors.deepOrange,
                'kcal',
              ),
            ),
            Obx(
              () => buildProgressRow(
                Icons.local_pizza,
                'Carbs',
                carbSlider.value,
                targetCarbs.value,
                Colors.orange,
                'g',
              ),
            ),
            Obx(
              () => buildProgressRow(
                Icons.fitness_center,
                'Proteins',
                proteinSlider.value,
                targetProteins.value,
                Colors.blue,
                'g',
              ),
            ),
            Obx(
              () => buildProgressRow(
                Icons.fastfood,
                'Fat',
                fatSlider.value,
                targetFat.value,
                Colors.red,
                'g',
              ),
            ),
            Obx(
              () => buildProgressRow(
                Icons.local_hospital,
                'Vitamin A',
                vitaminSlider.value,
                targetVitamins.value,
                Colors.green,
                'mcg',
              ),
            ),
            Obx(
              () => buildProgressRow(
                Icons.spa,
                'Salt',
                saltSlider.value,
                targetSalt.value,
                Colors.purple,
                'mg',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealTile(String title, int time, String date, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.food_bank, color: Colors.orangeAccent),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.green),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: SelectItems(
                        date: date,
                        time: time,
                        onUpdate: () => _updateNutrients(date),
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget buildProgressRow(
    IconData icon,
    String label,
    double value,
    double target,
    Color color,
    String unit,
  ) {
    double maxCapacity = target * 2.5;
    double greenFactor = 0.2;
    switch (label) {
      case 'Calories':
      case 'Carbs':
        greenFactor = 0.45;
        break;
      case 'Proteins':
        greenFactor = 0.25;
        break;
      case 'Fat':
        greenFactor = 0.2;
        break;
      case 'Vitamin A':
      case 'Salt':
        greenFactor = 0.1;
        break;
    }

    double optimalProgress = greenFactor;
    double actualProgress = (value / maxCapacity).clamp(0, 1);

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "${value.toStringAsFixed(1)} / ${target.toStringAsFixed(0)} $unit",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: optimalProgress,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: actualProgress,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// --- INITIALIZATION ---
  Future<void> _initializeData() async {
    await _ensureSignedIn();
    await loadUserGoals();
    _updateNutrients(nutritionController.currentDate.value);
  }

  Future<void> _ensureSignedIn() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) await auth.signInAnonymously();
  }

  Future<void> loadUserGoals() async {
    final data = await getUserData();
    if (data == null) return;

    final goal = data['Goal'] ?? 'Stay Healthy';
    final height = double.tryParse(data['Height']?.toString() ?? '') ?? 0;
    final weight = double.tryParse(data['Weight']?.toString() ?? '') ?? 0;

    double bmi = 0;
    if (height > 0) bmi = weight / ((height / 100) * (height / 100));

    userGoal.value = goal;
    userBMI.value = bmi;

    _updateTargetNutrients();
  }

  void _updateTargetNutrients() {
    double baseCarbs = 300,
        baseProteins = 150,
        baseFat = 80,
        baseVitamins = 1000,
        baseSalt = 2300;
    if (userGoal.value == "Weight Loss") {
      targetCarbs.value = baseCarbs * 0.8;
      targetProteins.value = baseProteins * 1.1;
      targetFat.value = baseFat * 0.8;
      targetCalories.value = 1800;
    } else if (userGoal.value == "Weight Gain") {
      targetCarbs.value = baseCarbs * 1.2;
      targetProteins.value = baseProteins * 1.2;
      targetFat.value = baseFat * 1.1;
      targetCalories.value = 2500;
    } else {
      targetCarbs.value = baseCarbs;
      targetProteins.value = baseProteins;
      targetFat.value = baseFat;
      targetCalories.value = 2000;
    }

    targetVitamins.value = baseVitamins;
    targetSalt.value = baseSalt;
  }

  /// --- NUTRIENT UPDATE LOGIC ---
  Future<void> _updateNutrients(String date) async {
    double calories = 0,
        carbs = 0,
        proteins = 0,
        fat = 0,
        vitaminA = 0,
        salt = 0;

    final et = nutritionController.check[date];
    if (et != null) {
      List<Item> allItems = [
        ...et.breakfast,
        ...et.lunch,
        ...et.dinner,
        ...et.other,
      ];

      for (var item in allItems) {
        if (!item.State) continue;

        final nutrition = await DatabaseHelper().getNutrition(item.Name);
        final cleanNutrition = nutrition.map((k, v) => MapEntry(k.trim(), v));
        double factor = (item.Amount > 0) ? (item.Amount / 100) : 1.0;

        // robust kcal parsing
        String? kcalStr = cleanNutrition['Energy (kcal) kJ']?.toString();
        double kcal = 0;
        if (kcalStr != null) {
          final match = RegExp(r'\((\d+)\)').firstMatch(kcalStr);
          kcal =
              match != null
                  ? double.tryParse(match.group(1)!) ?? 0
                  : double.tryParse(
                        RegExp(r'\d+').firstMatch(kcalStr)?.group(0) ?? '0',
                      ) ??
                      0;
        }

        calories += kcal * factor;
        carbs +=
            (cleanNutrition['Carbohydrate available (g)'] ?? 0).toDouble() *
            factor;
        proteins += (cleanNutrition['Protein (g)'] ?? 0).toDouble() * factor;
        fat += (cleanNutrition['Fat (g)'] ?? 0).toDouble() * factor;
        vitaminA +=
            (cleanNutrition['Vitamin A (mcg)'] ?? 0).toDouble() * factor;
        salt += (cleanNutrition['Na (mg)'] ?? 0).toDouble() * factor;
      }
    }

    nutrientTotals[date] = NutrientTotals(
      calories: calories,
      carbs: carbs,
      proteins: proteins,
      fat: fat,
      vitaminA: vitaminA,
      salt: salt,
    );

    caloriesSlider.value = calories;
    carbSlider.value = carbs;
    proteinSlider.value = proteins;
    fatSlider.value = fat;
    vitaminSlider.value = vitaminA;
    saltSlider.value = salt;
  }
}
