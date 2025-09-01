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

    return Scaffold(
            appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: timeline.DatePicker(
                startDate,
                initialSelectedDate: selectedDate,
                selectionColor: Colors.black,
                onDateChange: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDialog<DateTime>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 350,
                        width: 350,
                        child: FittedBox(
                          child: plus.DatePicker(
                            minDate: DateTime(2020, 1, 1),
                            maxDate: DateTime(2030, 12, 31),
                            initialDate: selectedDate,
                            onDateSelected: (date) {
                              Navigator.of(context).pop(date);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );

                if (picked != null) {
                  setState(() {
                    startDate = picked;
                  });
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildSliderRow('Carbs', carbSlider, (value) {
                    setState(() {
                      carbSlider = value;
                    });
                  }),
                  buildSliderRow('Proteins', proteinSldier, (value) {
                    setState(() {
                      proteinSldier = value;
                    });
                  }),
                  buildSliderRow('Fat', fatSlider, (value) {
                    setState(() {
                      fatSlider = value;
                    });
                  }),
                  buildSliderRow('Vitamins', vitaminSlider, (value) {
                    setState(() {
                      vitaminSlider = value;
                    });
                  }),
                  buildSliderRow('Salt', saltSlider, (value) {
                    setState(() {
                      saltSlider = value;
                    });
                  }),
                ],
              ),
            ),
            ListTile(
              title: const Text('Breakfast'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectItems(date: cleandate, time: 0),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
            ListTile(
              title: const Text('Lunch'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectItems(date: cleandate, time: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
            ListTile(
              title: const Text('Dinner'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectItems(date: cleandate, time: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
            ListTile(
              title: const Text('Other'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectItems(date: cleandate, time: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildSliderRow(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 16)),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          onChanged: onChanged,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
