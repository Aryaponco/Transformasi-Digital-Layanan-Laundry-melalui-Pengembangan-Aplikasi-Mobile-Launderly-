import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'notification_screen.dart';
import 'profile_user_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const DashboardScreen(),
      const NotificationScreen(),
      const ProfileUserScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[index],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          type: BottomNavigationBarType.fixed,
          elevation: 0,

          selectedItemColor: const Color(0xFF00BCD4),
          unselectedItemColor: Colors.grey.shade500,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 26),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded, size: 26),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 26),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
