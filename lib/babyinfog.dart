import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bottom_navigator.dart';

class BabyInfoPage extends StatefulWidget {
  @override
  State<BabyInfoPage> createState() => _BabyInfoPageState();
}

class _BabyInfoPageState extends State<BabyInfoPage> {
  int _selectedIndex = 0;
  bool _isEditMode = false; // Toggle between view and edit mode
  bool _isLoading = true; // Track loading state

  // Controllers for edit mode
  final TextEditingController _babyNameController = TextEditingController();
  final TextEditingController _babyDOBController = TextEditingController();
  final TextEditingController _babyWeightController = TextEditingController();
  final TextEditingController _babyGenderController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();

  // Dummy data for baby information
  Map<String, String> babyInfo = {
    "babyName": "Not Available",
    "babyDOB": "Not Available",
    "babyWeight": "Not Available",
    "babyGender": "Not Available",
    "motherName": "Not Available",
    "fatherName": "Not Available",
  };

  @override
  void initState() {
    super.initState();
    _fetchBabyInfo();
  }

  // Fetch baby info from Firestore
  Future<void> _fetchBabyInfo() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        // Fetch parent's name and role
        final String name = userData?['name'] ?? "Not Available";
        final String role = userData?['role'] ?? "Not Available";

        // Fetch baby info
        final DocumentSnapshot babyInfoDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('babyInfo')
            .doc('babyDetails')
            .get();

        if (babyInfoDoc.exists) {
          final Map<String, dynamic>? babyData = babyInfoDoc.data() as Map<String, dynamic>?;

          setState(() {
            babyInfo = {
              "babyName": babyData?['babyName'] ?? "Not Available",
              "babyDOB": babyData?['babyDOB'] ?? "Not Available",
              "babyWeight": babyData?['babyWeight'] ?? "Not Available",
              "babyGender": babyData?['babyGender'] ?? "Not Available",
              "motherName": role == "mother" ? name : "Not Available",
              "fatherName": role == "father" ? name : "Not Available",
            };

            // Set initial values for edit mode
            _babyNameController.text = babyInfo["babyName"]!;
            _babyDOBController.text = babyInfo["babyDOB"]!;
            _babyWeightController.text = babyInfo["babyWeight"]!;
            _babyGenderController.text = babyInfo["babyGender"]!;
            _motherNameController.text = babyInfo["motherName"]!;
            _fatherNameController.text = babyInfo["fatherName"]!;
          });
        }
      }
    } catch (e) {
      print("Error fetching baby info: $e");
    } finally {
      setState(() {
        _isLoading = false; // Data fetching is complete
      });
    }
  }

  // Save updated baby info to Firestore
  Future<void> _saveBabyInfo() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('babyInfo')
          .doc('babyDetails')
          .set({
        'babyName': _babyNameController.text,
        'babyDOB': _babyDOBController.text,
        'babyWeight': _babyWeightController.text,
        'babyGender': _babyGenderController.text,
      });

      // Fetch updated data
      _fetchBabyInfo();
      _toggleEditMode();
    } catch (e) {
      print("Error saving baby info: $e");
    }
  }
 
  final TextEditingController _babyDobController = TextEditingController();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }


  Future<void> _fetchBabyInfoFromBackend() async {
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

  Future<void> _updateBabyInfoFromBackend() async {
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
      backgroundColor: Color(0xFFFFF4DE), // Soft Cream Background
      appBar: AppBar(
        title: Text(
          "Baby Information",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF67E7D), // Coral Pink App Bar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.close : Icons.edit, color: Colors.black),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _isEditMode ? _buildEditMode() : _buildViewMode(),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // View Mode
  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard("Baby's Name", babyInfo["babyName"] ?? "Not Available"),
        _buildInfoCard("Date of Birth", babyInfo["babyDOB"] ?? "Not Available"),
        _buildInfoCard("Weight", babyInfo["babyWeight"] ?? "Not Available"),
        _buildInfoCard("Gender", babyInfo["babyGender"] ?? "Not Available"),
        _buildInfoCard("Mother's Name", babyInfo["motherName"] ?? "Not Available"),
        _buildInfoCard("Father's Name", babyInfo["fatherName"] ?? "Not Available"),
      ],
    );
  }

  // Edit Mode
  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Baby's Name", _babyNameController),
        _buildTextField("Date of Birth", _babyDOBController),
        _buildTextField("Weight", _babyWeightController),
        _buildTextField("Gender", _babyGenderController),
        _buildTextField("Mother's Name", _motherNameController, enabled: false),
        _buildTextField("Father's Name", _fatherNameController, enabled: false),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _saveBabyInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C3A82), // Purple Button
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
    );
  }

  // Info Card for View Mode
  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Text Field for Edit Mode
  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
