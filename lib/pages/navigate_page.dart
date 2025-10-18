import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/account_page.dart';
import 'package:nutrition_calender/components/home_page.dart';
import 'package:nutrition_calender/components/track_page.dart';

final List<Widget> _pages = [
  HomePage(),
  TrackPage(),
  AccountPage(),
];

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

class _NavigatePageState extends State<NavigatePage> {
  int currentIndex = 0;
  int previousIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final isForward = currentIndex > previousIndex;

          final offsetAnimation = Tween<Offset>(
            begin: Offset(isForward ? 1.0 : -1.0, 0), // slide from right or left
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: KeyedSubtree(
          // Using a unique key ensures AnimatedSwitcher recognizes the page change
          key: ValueKey<int>(currentIndex),
          child: _pages[currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: _navItems,
        onTap: (value) {
          setState(() {
            previousIndex = currentIndex;
            currentIndex = value;
          });
        },
      ),
    );
  }
}
