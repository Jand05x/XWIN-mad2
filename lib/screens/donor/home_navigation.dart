import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'account_screen.dart';
import 'settings_screen.dart';

// Bottom navigation for donor screens
// Contains Dashboard, Account, and Settings tabs
class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  // Track which tab is selected
  int currentIndex = 0;

  // List of screens for each tab
  final List<Widget> screens = [
    DashboardScreen(),
    AccountScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show the current screen
      body: screens[currentIndex],
      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Color(0xFFC62828),
          unselectedItemColor: Color(0xFFBDBDBD),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            // Home tab
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 26),
              label: 'Home',
            ),
            // Profile tab
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 26),
              label: 'Profile',
            ),
            // Settings tab
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded, size: 26),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
