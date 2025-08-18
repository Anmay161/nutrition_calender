import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/data_dummy.dart';

class CheckitemsPage extends StatefulWidget {
  String date = '';
  int time = -1;
  CheckitemsPage({super.key, required this.date, required this.time});

  @override
  State<CheckitemsPage> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<CheckitemsPage> {
  @override
  Widget build(BuildContext context) {
    var value = getSelectedList(check[widget.date], widget.time);

    return Scaffold(
      appBar: AppBar(title: Text('Food')),
      body: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: value[index].state,
            title: Text(value[index].name),
            onChanged: (newvalue) {
              setState(() {
                value[index].state = newvalue!;
              });
            },
          );
        },
      ),
    );
  }
}

List<Item> getSelectedList(EatingTime? et, int time) {
  if (et == null) return [];

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
