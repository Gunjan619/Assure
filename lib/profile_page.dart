import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For clearing login state
import 'bottom_navigator.dart'; // Assuming this is your custom bottom navigation bar

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  int _selectedIndex = 4;
  bool _isEditing = false;

  // Dummy profile data
  String name = "John Doe";
  String mobile = "123-456-7890";
  String gender = "Male";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        // Populate the text fields with current data when editing
        nameController.text = name;
        mobileController.text = mobile;
        genderController.text = gender;
      } else {
        // Save the data when done editing
        name = nameController.text;
        mobile = mobileController.text;
        gender = genderController.text;
      }
    });
  }

  // Logout function
  Future<void> _logout() async {
    // Clear secure storage (e.g., auth token)
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'authToken');

    // Clear SharedPreferences (e.g., login state)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigate to the SignInPage or any other login screen
    Navigator.pushReplacementNamed(context, '/signin'); // Replace with your login route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4DE), // Soft Cream Background
      appBar: AppBar(
        title: const Text("Manage Your Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFFF67E7D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing) ...[
                buildTextField("Name", nameController),
                SizedBox(height: 15),
                buildTextField("Mobile Number", mobileController),
                SizedBox(height: 15),
                buildTextField("Gender", genderController),
              ] else ...[
                buildProfileInfo("Name", name),
                SizedBox(height: 15),
                buildProfileInfo("Mobile Number", mobile),
                SizedBox(height: 15),
                buildProfileInfo("Gender", gender),
              ],
              SizedBox(height: 30),
              if (_isEditing)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _toggleEditing();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C3A82), // Purple Button
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Save Profile",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              SizedBox(height: 20),
              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for logout
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6C3A82), // Purple Text
          ),
        ),
        SizedBox(height: 5),
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: "Enter $label",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6C3A82), // Purple Text
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
            BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
            )
            ],
          ),
          child: Text(
            value.isNotEmpty ? value : "Not available",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}