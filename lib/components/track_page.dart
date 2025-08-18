import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/tracking_pages/history_page.dart';
import 'package:nutrition_calender/components/tracking_pages/today_page.dart';

final List<Widget> _pages = [TodayPage(),HistoryPage()];
var selectedIndex = 0;

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            icon: Icon(Icons.today),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            icon: Icon(Icons.track_changes),
          ),
        ],
      ),
      body: _pages[selectedIndex],
    );
  }
}
