import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bottom_navigator.dart';

class GrowthHistoryScreen extends StatefulWidget {
  @override
  State<GrowthHistoryScreen> createState() => _GrowthHistoryScreenState();
}

class _GrowthHistoryScreenState extends State<GrowthHistoryScreen> {
  int _selectedIndex = 0;
  String selectedTab = 'Weight';
  TextEditingController inputController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addData() {
    String value = inputController.text.trim();
    if (value.isNotEmpty) {
      FirebaseFirestore.instance.collection('growth_history').add({
        'type': selectedTab,
        'value': value,
        'date': DateTime.now().toIso8601String(),
      });
      inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFFFF4DE), // Soft Cream Background
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF67E7D), // Coral Pink App Bar
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Growth History',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                  onTap: (index) => setState(() => selectedTab = index == 0 ? 'Weight' : 'Height'),
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFC977ED), Color(0xFFF8A16D)], // Gradient Indicator
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
              Tab(
              child: Text(
              'Weight',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
              Tab(
                child: Text(
                    'Height',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  GrowthTabView(
                      type: 'Weight',
                      inputController: inputController,
                      onAdd: _addData),
                  GrowthTabView(
                      type: 'Height',
                      inputController: inputController,
                      onAdd: _addData),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

class GrowthTabView extends StatelessWidget {
  final String type;
  final TextEditingController inputController;
  final VoidCallback onAdd;

  GrowthTabView({
    required this.type,
    required this.inputController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Image.asset(
              type == 'Weight' ? 'Images/graph.png' : 'Images/graph2.png',
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('growth_history')
                .where('type', isEqualTo: type)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No data to show",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFBE4B2), Color(0xFFF67E7D)], // Gradient Background
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                  child: Table(
                    columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(2), 2: FlexColumnWidth(1)},
                    border: TableBorder(
                        horizontalInside:
                        BorderSide(width: 1, color: Colors.grey[300]!)),
                    children: [
                      TableRow(children: [
                        tableCell('Date', true),
                        tableCell(type, true),
                      ]),
                      ...snapshot.data!.docs.map((doc) {
                        return TableRow(children: [
                          tableCell(doc['date'].substring(0, 10), false),
                          tableCell(doc['value'], false),
                        ]);
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintText: 'Update Your Baby’s $type',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C3A82), // Purple Button
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tableCell(String text, bool isHeader) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 13),
      ),
    );
  }
}