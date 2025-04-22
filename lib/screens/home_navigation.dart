import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'video_lesson_screen.dart';
import 'report_form_screen.dart';
import 'profile_screen.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens =  [
    DashboardScreen(),
    VideoLessonScreen(),
    ReportFormScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _bottomItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      label: 'Самбар',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.play_circle_outline),
      label: 'Сургалт',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.warning_amber_rounded),
      label: 'Мэдээ',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: 'Профайл',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: _bottomItems,
        ),
      ),
    );
  }
}
