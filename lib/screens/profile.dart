import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'technician.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coming Soon'),
        ),
        body: const Center(
          child: Text('Coming Soon'),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TechnicianScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}
