import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'Basic Info/chatbot.dart';
import 'babyinfog.dart';
import 'home_main.dart'; // Import the Home_main class
import 'profile_page.dart'; // Import the ProfilePage class

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: Color(0xFFFBE4B2),
      selectedItemColor: Color(0xFF6C3A82),
      unselectedItemColor: Colors.black54,
      onTap: (index) {
        if (index == 1) {
          // Redirect to BabyInfoPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BabyInfoPage()),
          );
        } else if (index == 2) {
          // Redirect to ChatBotScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBotScreen()),
          );
        } else if (index == 0) {
          // Redirect to Home_main
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home_main()),
          );
        } else if (index == 4) {
          // Redirect to ProfilePage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        } else {
          onItemTapped(index);
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.child_care), label: ''),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidCommentDots), label: ''), // Chat bot button
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(MdiIcons.tshirtCrew, size: 20),
              Icon(FontAwesomeIcons.shoePrints, size: 20),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}