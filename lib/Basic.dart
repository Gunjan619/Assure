import 'package:flutter/material.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selectedRole = ''; // To store the selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.6, 0.6),
            colors: [
              Color(0xFFFDBA74), // Gradient color
              Colors.white,      // White towards the bottom
            ],
            stops: [0.0, 0.7], // Extend gradient to touch the avatar
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              // Logo with text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'Images/logo2.png', // Add your logo asset here
                    height: 50,
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 40),
              // Welcome text
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              // Subtitle
              Text(
                "Let's start by learning a little about you.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // Avatar upload section
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange.shade100,
                child: ClipOval(
                  child: Image.asset(
                    'Images/Avatar.png', // Add your avatar image here
                    width: 80,
                    height: 80,
                  ),
                ),
              ),
              SizedBox(height: 10),

              SizedBox(height: 30),
              // Name input field
              TextField(
                decoration: InputDecoration(
                  labelText: "What's your name?",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Role selection section
              Text(
                "What's your role?",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 10),
              // Role selection buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RoleButton(
                    icon: Icons.man,
                    label: 'Father',
                    isSelected: selectedRole == 'Father',
                    onTap: () {
                      setState(() {
                        selectedRole = 'Father';
                      });
                    },
                    color: selectedRole == 'Father'
                        ? Color(0xFFF38A3A) // Warm orange for selection
                        : Color(0xFFFFE3C9), // Soft peach when not selected
                  ),
                  RoleButton(
                    icon: Icons.woman,
                    label: 'Mother',
                    isSelected: selectedRole == 'Mother',
                    onTap: () {
                      setState(() {
                        selectedRole = 'Mother';
                      });
                    },
                    color: selectedRole == 'Mother'
                        ? Color(0xFFF38A3A) // Warm orange for selection
                        : Color(0xFFFFE3C9), // Soft peach when not selected
                  ),
                ],
              ),
              Spacer(),
              // Page indicator and next button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1 of 4',
                    style: TextStyle(color: Colors.black54),
                  ),
                  ElevatedButton(
                    onPressed: selectedRole.isNotEmpty ? () {
                      // Add your navigation functionality here
                    } : null, // Disable button if no role selected
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                      backgroundColor: selectedRole.isNotEmpty
                          ? Colors.blue
                          : Colors.grey, // Change color when disabled
                    ),
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class RoleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color; // Add color parameter for custom color

  RoleButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color, // Initialize the custom color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color, // Use the passed color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.transparent,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 30, color: Colors.orangeAccent),
            ),
            SizedBox(height: 8),
            // Change the text color based on selection
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black54, // White when selected, black when not
              ),
            ),
          ],
        ),
      ),
    );
  }
}
