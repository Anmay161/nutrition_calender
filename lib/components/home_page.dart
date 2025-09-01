import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart' as timeline;
import 'package:nutrition_calender/components/select_items.dart';
import 'package:nutrition_calender/components/data_dummy.dart';
import 'package:date_picker_plus/date_picker_plus.dart' as plus;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedDate = DateTime.now();
  var startDate = DateTime.now();
  double carbSlider = 0;
  double proteinSldier = 0;
  double fatSlider = 0;
  double vitaminSlider = 0;
  double saltSlider = 0;

  @override
  Widget build(BuildContext context) {
    var cleandate = selectedDate.toString().split(' ').first;
    getdate = cleandate;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black26,
          titleSpacing: 0, // remove default padding
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: timeline.DatePicker(
                      startDate,
                      initialSelectedDate: selectedDate,
                      selectionColor: Colors.blueAccent,
                      selectedTextColor: Colors.white,
                      daysCount: 100, // optional: restrict visible days
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
                        setState(() {
                          selectedDate = date;
                        });
                      },
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
                          builder: (context) {
                            return Dialog(
                              insetPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.9,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.7,
                                ),
                                child: plus.DatePicker(
                                  minDate: DateTime(2020, 1, 1),
                                  maxDate: DateTime(2030, 12, 31),
                                  initialDate: selectedDate,
                                  onDateSelected: (date) {
                                    Navigator.of(context).pop(date);
                                  },
                                ),
                              ),
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() {
                            startDate = picked;
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nutrient Sliders
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildSliderRow(
                      Icons.local_pizza,
                      'Carbs',
                      carbSlider,
                      (value) => setState(() => carbSlider = value),
                    ),
                    buildSliderRow(
                      Icons.fitness_center,
                      'Proteins',
                      proteinSldier,
                      (value) => setState(() => proteinSldier = value),
                    ),
                    buildSliderRow(
                      Icons.fastfood,
                      'Fat',
                      fatSlider,
                      (value) => setState(() => fatSlider = value),
                    ),
                    buildSliderRow(
                      Icons.local_hospital,
                      'Vitamins',
                      vitaminSlider,
                      (value) => setState(() => vitaminSlider = value),
                    ),
                    buildSliderRow(
                      Icons.spa,
                      'Salt',
                      saltSlider,
                      (value) => setState(() => saltSlider = value),
                    ),
                  ],
                ),
              ),
            ),

            // Meals Section
            const Text(
              "Meals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            buildMealTile("Breakfast", Icons.free_breakfast, cleandate, 0),
            buildMealTile("Lunch", Icons.lunch_dining, cleandate, 1),
            buildMealTile("Dinner", Icons.dinner_dining, cleandate, 2),
            buildMealTile("Other", Icons.restaurant, cleandate, 3),
          ],
        ),
      ),
    );
  }

  Widget buildSliderRow(
    IconData icon,
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
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
              "${value.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 20,
          label: "${value.toStringAsFixed(0)}%",
          activeColor: Colors.blueAccent,
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildMealTile(String title, IconData icon, String date, int time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectItems(date: date, time: time),
              ),
            );
          },
        ),
      ),
    );
  }
}
