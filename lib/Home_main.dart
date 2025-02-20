import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Basic Info/Blog.dart';
import 'Basic Info/Memo.dart';
import 'Basic Info/forum.dart';
import 'Basic Info/weight.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bottom_navigator.dart';

class Home_main extends StatefulWidget {
  @override
  State<Home_main> createState() => _Home_mainState();
}

class _Home_mainState extends State<Home_main> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Center(child: Image.asset("Images/First Blob.png")),
            SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              children: [
                ActivityCard(title: "Last feed", time: "1h 28m ago", icon: Icons.restaurant, color: Colors.pinkAccent),
                ActivityCard(title: "Today", time: "1h 28m", icon: Icons.nightlight, color: Colors.blueAccent),
                ActivityCard(title: "Last changed", time: "1h 28m ago", icon: Icons.baby_changing_station, color: Colors.greenAccent),
                ActivityCard(title: "Today", time: "1h 28m", icon: Icons.access_time, color: Colors.orangeAccent),
              ],
            ),
            SizedBox(height: 16),
            Center(child: Text("\"quick AI message/suggestion\"", style: TextStyle(fontStyle: FontStyle.italic))),
            SizedBox(height: 16),
            Text("New features", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FeatureIcon(title: "Track growth", icon: Icons.timeline, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GrowthHistoryScreen()))),
                FeatureIcon(title: "Forum", icon: Icons.chat, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForumPage()))),
                FeatureIcon(title: "Memories", icon: Icons.camera_alt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Memo()))),
                FeatureIcon(title: "Blog", icon: Icons.article, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Blog()))),
              ],
            ),
            SizedBox(height: 16),
            Text("Meet our writers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    color: Colors.grey[300],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Baby at this age should eat these ......."),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  ActivityCard({required this.title, required this.time, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 5),
          Text(time, style: TextStyle(color: Colors.white, fontSize: 14)),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}


class FeatureIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  FeatureIcon({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 30),
          ),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}