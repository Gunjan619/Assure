import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GrowthHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // For Weight and Height tabs
      child: Scaffold(
        backgroundColor: Color(0xFFEFB385), // light beige background
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFFBE4B2),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),
          title: Text(
            'Growth History',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // TabBar for Weight and Height
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Color(0xFFEFB385), // Peach background color for the TabBar container
              child: TabBarWidget(), // Modified TabBar for Weight and Height
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Weight graph section
                  WeightTabView(),
                  // Height graph section
                  HeightTabView(),
                ],
              ),
            ),
          ],
        ),
        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFFBE4B2),
          selectedItemColor: Color(0xFF6C3A82), // Highlight selected icon with deep purple
          unselectedItemColor: Colors.black54,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidCommentDots),
              label: '',
            ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEFB385), // Set the same background color for the container
      ),
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        indicator: BoxDecoration(
          color: Color(0xFFFBE4B2), // Set this color for the selected tab
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.black, // Text color for active tab
        unselectedLabelColor: Colors.black54, // Text color for inactive tabs
        tabs: [
          Tab(
            child: Text('Weight', style: TextStyle(fontSize: 16)),
          ),
          Tab(
            child: Text('Height', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class WeightTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Weight graph
          Container(
            color: Color(0xFFEFB385),
            padding: EdgeInsets.all(20),
            child: Image.asset('Images/graph.png', fit: BoxFit.cover), // Replace with actual graph image
          ),
          // Past History Table with improved background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Past History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: HistoryTable(heightMode: false),
                ),
              ],
            ),
          ),
          // Weight Update Section
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFEFB385),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Update Your Baby’s Weight',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C3A82), // deep purple
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Add', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeightTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Height graph
          Container(
            color: Color(0xFFEFB385),
            padding: EdgeInsets.all(20),
            child: Image.asset('Images/graph2.png', fit: BoxFit.cover), // Replace with actual graph image
          ),
          // Past History Table for height
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Past History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: HistoryTable(heightMode: true),
                ),
              ],
            ),
          ),
          // Height Update Section
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFFEFB385),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Update Your Baby’s Height',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C3A82), // deep purple
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Add', style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryTable extends StatelessWidget {
  final bool heightMode; // Distinguish between weight and height

  HistoryTable({required this.heightMode});

  final List<Map<String, String>> historyData = [
    {'date': '3 Oct 2024', 'age': '9 months', 'value': '3 Kg'}, // Replace with actual data
    {'date': '5 Sep 2024', 'age': '8 months', 'value': '2.8 Kg'},
    {'date': '7 Aug 2024', 'age': '7 months', 'value': '2.6 Kg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.grey[300]!),
        verticalInside: BorderSide.none,
      ),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Date',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Age',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                heightMode ? 'Height' : 'Weight', // Switch between height and weight
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
        ...historyData.map((row) {
          return TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(row['date']!, style: TextStyle(color: Colors.black87)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(row['age']!, style: TextStyle(color: Colors.black87)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(row['value']!, style: TextStyle(color: Colors.black87)),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
