import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/data_dummy.dart';
import 'package:nutrition_calender/components/search_items.dart';

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
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SearchItems(
                    date: widget.date,
                    time: widget.time,
                  ),
                ),
              );
            },
          );
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
