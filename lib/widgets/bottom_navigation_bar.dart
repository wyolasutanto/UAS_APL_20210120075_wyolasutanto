import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Technician',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.build),
          label: 'Coming Soon',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.cyan,
      onTap: onTap,
    );
  }
}
