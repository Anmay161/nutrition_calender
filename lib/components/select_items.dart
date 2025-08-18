import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/data_dummy.dart';



class SelectItems extends StatefulWidget {
  String date = '';
  int time = -1;
  SelectItems({super.key, required this.date, required this.time});

  @override
  State<SelectItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  @override
  Widget build(BuildContext context) {
    var value = getSelectedList(check[widget.date], widget.time);

    return Scaffold(
      appBar: AppBar(title: Text('Food')),
      body: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(value[index].name),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  value.removeAt(index);
                });
              },
              icon: Icon(Icons.delete),
            ),
          );
        },
      ),
      bottomNavigationBar: IconButton(
        onPressed: () {
          if (!check.containsKey(widget.date)) {
            check[widget.date] = EatingTime();
            value = getSelectedList(check[widget.date], widget.time);
          }
          setState(() {
            value.add(Item('Pizza', false));
          });
        },
        icon: Icon(Icons.add),
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
