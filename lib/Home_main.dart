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
      backgroundColor: Color(0xFFFFF4DE), // Soft Cream Background
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
            BabyMilestoneCard(),
            SizedBox(height: 10),

            // Activity Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                ActivityCard(
                  title: "Last feed",
                  time: "1h 28m ago",
                  icon: Icons.restaurant,
                  color1: Color(0xFFC977ED),
                  color2: Color(0xFFF8A16D),

                ),
                ActivityCard(
                  title: "Today",
                  time: "1h 28m",
                  icon: Icons.nightlight,
                  color1: Color(0xFFC977ED),
                  color2: Color(0xFFF8A16D),
                ),
                ActivityCard(
                  title: "Last changed",
                  time: "1h 28m ago",
                  icon: Icons.baby_changing_station,
                  color1: Color(0xFFC977ED),
                  color2: Color(0xFFF8A16D),
                ),
                ActivityCard(
                  title: "Today",
                  time: "1h 28m",
                  icon: Icons.access_time,
                  color1: Color(0xFFC977ED),
                  color2: Color(0xFFF8A16D),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Quick AI Message
            Center(
              child: Text(
                "\"Quick AI message/suggestion\"",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Color(0xFF6B4A4A),
                ),
              ),
            ),
            SizedBox(height: 24),

            // New Features Section
            Text(
              "New Features",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D2C2C),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FeatureIcon(
                  title: "Track growth",
                  icon: Icons.timeline,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GrowthHistoryScreen()),
                  ),
                ),
                FeatureIcon(
                  title: "Forum",
                  icon: Icons.chat,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForumPage()),
                  ),
                ),
                FeatureIcon(
                  title: "Memories",
                  icon: Icons.camera_alt,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Memo()),
                  ),
                ),
                FeatureIcon(
                  title: "Blog",
                  icon: Icons.article,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Blog()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Meet Our Writers Section
            Text(
              "Meet Our Writers",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("Images/banner.jpg"), // Replace with your image
                        fit: BoxFit.cover,
                      ),

                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Baby at this age should eat these...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
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
  final Color color1;
  final Color color2;

  ActivityCard({
    required this.title,
    required this.time,
    required this.icon,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9B6C6C).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
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

  FeatureIcon({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFEED9C4),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF9B6C6C).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 30,
              color: Color(0xFFB28FCD),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D2C2C),
            ),
          ),
        ],
      ),
    );
  }
}

class BabyMilestoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the card
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
              color: Colors.black12, // Soft shadow
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
          )
              ],
          gradient: LinearGradient(
          colors: [
          Color(0xFFFFF4DE), // Soft Cream
          Color(0xFFF8A16D), // Light Coral
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    // Baby Image/Animation
    Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
    image: AssetImage("Images/First Blob.png"), // Replace with your image
    fit: BoxFit.cover,
    ),
    border: Border.all(
    color: Color(0xFFF67E7D), // Coral Pink border
    width: 2,
    ),
    ),
    ),
    SizedBox(width: 16),

    // Milestone Details
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Baby Name
    Text(
    "Baby Name",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF6C3A82), // Purple text
    ),
    ),
    SizedBox(height: 8),

    // Progress Bar
    LinearProgressIndicator(
    value: 0.6, // Dynamic progress value
    backgroundColor: Colors.grey[200],
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF67E7D)), // Coral Pink
    ),
    SizedBox(height: 8),

    // Active Milestone
    Text(
    "Active Milestone: First 3 Months",
    style: TextStyle(
    fontSize: 14,
    color: Color(0xFF6C3A82).withOpacity(0.8), // Purple with opacity
    ),
    ),
    SizedBox(height: 8),

    // Icons and Stats
    Row(
    children: [
    Icon(Icons.access_time, size: 16, color: Color(0xFF6C3A82)), // Purple icon
    SizedBox(width: 4),
    Text(
    "45m",
    style: TextStyle(
    fontSize: 14,
    color: Color(0xFF6C3A82).withOpacity(0.8), // Purple text
    ),
    ),
    SizedBox(width: 16),
    Icon(Icons.cake, size: 16, color: Color(0xFF6C3A82)), // Purple icon
    SizedBox(width: 4),
    Text(
    "3.5kg",
    style: TextStyle(
    fontSize: 14,
    color: Color(0xFF6C3A82).withOpacity(0.8), // Purple text
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    ],
    ),
    );
    }
}