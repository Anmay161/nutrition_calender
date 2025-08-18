import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/data_dummy.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final items = check.entries.toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: check.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(items[index].key));
        },
      ),
    );
  }
}
