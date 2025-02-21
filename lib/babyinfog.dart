import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'bottom_navigator.dart';

class BabyInfoPageEdit extends StatefulWidget {
  @override
  State<BabyInfoPageEdit> createState() => _BabyInfoPageEditState();
}

class _BabyInfoPageEditState extends State<BabyInfoPageEdit> {
  int _selectedIndex = 0;
  final TextEditingController _babyNameController = TextEditingController();
  final TextEditingController _babyDobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBabyInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchBabyInfo() async {
    final url = dotenv.env['BACKEND_URL'];
    final storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken');
    if (url != null && authToken != null) {
      try {
        final response = await http.get(
          Uri.parse('$url/api/babies/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          setState(() {
            _babyNameController.text = responseData['name'];
            _babyDobController.text = responseData['dob'];
          });
        } else {
          print("Failed to fetch baby info from the backend: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching baby info from the backend: $e");
      }
    } else {
      print("Backend URL or auth token is not set.");
    }
  }

  Future<void> _updateBabyInfo() async {
    final url = dotenv.env['BACKEND_URL'];
    final storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken');
    if (url != null && authToken != null) {
      try {
        final response = await http.put(
          Uri.parse('$url/api/babies/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode({
            'name': _babyNameController.text,
            'dob': _babyDobController.text,
          }),
        );
        if (response.statusCode == 200) {
          print("Baby info successfully updated!");
        } else {
          print("Failed to update baby info: ${response.statusCode}");
        }
      } catch (e) {
        print("Error updating baby info: $e");
      }
    } else {
      print("Backend URL or auth token is not set.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFCEEC1), // Light beige background
        body: Column(
          children: [
            // Greeting Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Color(0xFFF8A16D), // Orange background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Text(
                  "Hi,\nmother",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9E1B1B), // Dark red color
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Form Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update your baby information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),

                  // Baby Name Field
                  Text("Baby Name"),
                  SizedBox(height: 5),
                  TextField(
                    controller: _babyNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Baby DOB Field
                  Text("Baby date of birth"),
                  SizedBox(height: 5),
                  TextField(
                    controller: _babyDobController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _updateBabyInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Blue button
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),


        );
    }
}
