import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:nutrition_calender/components/select_items.dart';
import 'package:nutrition_calender/components/data_dummy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedDate = DateTime.now();
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
        title: DatePicker(
          DateTime.now(),
          initialSelectedDate: selectedDate,
          selectionColor: Colors.black,
          onDateChange: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('Carbs'),
                  Slider(
                    value: carbSlider,
                    onChanged: (value) {
                      setState(() {
                        carbSlider = value;
                      });
                    },
                  ),

                  Text('Proteins'),
                  Slider(
                    value: proteinSldier,
                    onChanged: (value) {
                      setState(() {
                        proteinSldier = value;
                      });
                    },
                  ),
              

                  Text('Fat'),
                  Slider(
                    value: fatSlider,
                    onChanged: (value) {
                      setState(() {
                        fatSlider = value;
                      });
                    },
                  ),
              

                  Text('Vitamins'),
                  Slider(
                    value: vitaminSlider,
                    onChanged: (value) {
                      setState(() {
                        vitaminSlider = value;
                      });
                    },
                  ),

                  Text('Salt'),
                  Slider(
                    value: saltSlider,
                    onChanged: (value) {
                      setState(() {
                        saltSlider = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Breakfast'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SelectItems(date: cleandate, time: 0),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
            ListTile(
              title: Text('Lunch'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SelectItems(date: cleandate, time: 1),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
            ListTile(
              title: Text('Dinner'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SelectItems(date: cleandate, time: 2),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
            ListTile(
              title: Text('Other'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SelectItems(date: cleandate, time: 3),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
