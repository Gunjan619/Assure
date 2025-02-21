import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'Basic Info/chatbot.dart';
import 'babyinfog.dart';


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
          // BabyInfoPageEdit screen open karega
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BabyInfoPage()),
          );
        } else if (index == 2) {
          // ChatBotScreen open karega
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBotScreen()),
          );
        } else {
          onItemTapped(index);
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.child_care), label: ''),
        BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.solidCommentDots), label: ''), // Chat bot button
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
