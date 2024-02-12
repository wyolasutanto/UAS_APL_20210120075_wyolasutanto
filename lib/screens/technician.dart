// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'profile.dart';

class TechnicianScreen extends StatelessWidget {
  TechnicianScreen({super.key});

  final List<Map<String, dynamic>> technicians = [
    {
      'name': 'Alexander Jacob',
      'specialization': 'Deep Cleaning, Rakit PC',
      'experience': '+3 years',
      'instagram': 'azazourya',
      'profileImage': 'assets/tech_photo/tech1.jpg',
    },
    {
      'name': 'Jonathan Devon',
      'specialization': 'Peripheral Cleaning, Rakit PC',
      'experience': '1 year',
      'instagram': 'dev.ons_',
      'profileImage': 'assets/tech_photo/tech2.jpg',
    },
    {
      'name': 'Wyola Sutanto',
      'specialization': 'Basic Cleaning',
      'experience': '1 year',
      'instagram': 'duyoldotcom',
      'profileImage': 'assets/tech_photo/tech3.jpeg',
    },
    // Add more technicians as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Technicians'),
        ),
        body: ListView.builder(
          itemCount: technicians.length,
          itemBuilder: (context, index) {
            final technician = technicians[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Sesuaikan nilai sesuai keinginan Anda
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  tileColor: Colors.lightBlue[50], // Set the background color of the ListTile to light blue
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(technician['profileImage']),
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(
                    technician['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(technician['specialization']),
                  trailing: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      _launchInstagram(technician['instagram']);
                    },
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _launchInstagram(String username) async {
  final instagramUrl = 'https://www.instagram.com/$username';
  
  if (await canLaunch(instagramUrl)) {
    await launch(instagramUrl);
  } else {
    // Jika tidak dapat membuka Instagram, buka melalui browser
    final browserUrl = 'https://www.instagram.com/$username';
    
    if (await canLaunch(browserUrl)) {
      await launch(browserUrl);
    } else {
      // Handle the case where both Instagram and browser cannot be launched.
      // ignore: avoid_print
      print('Could not launch $instagramUrl or $browserUrl');
    }
  }
}
}
