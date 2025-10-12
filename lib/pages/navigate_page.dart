import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/account_page.dart';
import 'package:nutrition_calender/components/home_page.dart';
import 'package:nutrition_calender/components/track_page.dart';

final List<dynamic> _pages = [HomePage(), TrackPage(), AccountPage()];

final List<BottomNavigationBarItem> _navItems = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
];

class NavigatePage extends StatefulWidget {
  const NavigatePage({super.key});

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

var currentIndex = 0;

class _NavigatePageState extends State<NavigatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: _navItems,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
