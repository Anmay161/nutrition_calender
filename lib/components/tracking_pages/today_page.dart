import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/checkitems_page.dart';
import 'package:nutrition_calender/components/data_dummy.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  var checkdate = getdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checkdate),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Breakfast'),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckitemsPage(date: checkdate, time: 0),
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
                    builder: (context) => CheckitemsPage(date: checkdate, time: 1),
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
                    builder: (context) => CheckitemsPage(date: checkdate, time: 2),
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
                    builder: (context) => CheckitemsPage(date: checkdate, time: 3),
                  ),
                );
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}