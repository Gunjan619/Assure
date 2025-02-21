import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assure/Basic%20Info/2nd.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert'; // Add this line to import dart:convert package
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await dotenv.load(fileName: ".env"); // Load environment variables
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomeScreen(),
  ));
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selectedRole = ''; // To store the selected role
  TextEditingController nameController = TextEditingController(); // Controller for name input

  // Function to store data in Firebase Firestore

  Future<void> storeDataToFirestore() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return;
      }

      // Log the data being sent to Firestore
      print("Storing data: name=${nameController.text.trim()}, role=$selectedRole");

      // Add data to Firestore with the user's UID as the document ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Use the user's UID as the document ID
          .set({
        'name': nameController.text.trim(),
        'role': selectedRole,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Data successfully stored in Firestore!");
    } catch (e) {
      print("Error storing data: $e");
    }
  }

  // Function to send data to the backend
  Future<void> sendDataToBackend() async {
    final url = dotenv.env['BACKEND_URL'];
    final storage = FlutterSecureStorage();
    final authToken = await storage.read(key: 'authToken');
    if (url != null) {
      try {
        final response = await http.put(
          Uri.parse('$url/api/profile/'),
            headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
            },
          body: jsonEncode({
            'name': nameController.text,
            'role': selectedRole,
          }),
        );
        if (response.statusCode == 200) {
          print("Data successfully sent to the backend!");
        } else {
          print("Failed to send data to the backend: ${response.statusCode}");
        }
      } catch (e) {
        print("Error sending data to the backend: $e");
      }
    } else {
      print("Backend URL is not set in the environment variables.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              size: Size(double.infinity, MediaQuery.of(context).size.height),
              painter: GradientBoxPainter(),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Image.asset(
                          'Images/logo2.png',
                          height: 60,
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Let's start by learning a little about you.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5A5A5A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFFBB86FC),
                          child: ClipOval(
                            child: Image.asset(
                              'Images/Avatar.png',
                              width: 90,
                              height: 90,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: nameController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "What's your name?",
                            labelStyle: TextStyle(color: Colors.black54),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.purple.shade400),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {}); // Update the button state dynamically
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          "What's your role?",
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        SizedBox(height: 10),
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
                                  ? Color(0xFFBB86FC)
                                  : Color(0xFFFFE0E0),
                              borderColor: selectedRole == 'Father'
                                  ? Colors.white
                                  : Colors.transparent,
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
                                  ? Color(0xFFBB86FC)
                                  : Color(0xFFFFE0E0),
                              borderColor: selectedRole == 'Mother'
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 40),
                            Text(
                              '1 of 3',
                              style: TextStyle(color: Colors.black54),
                            ),
                            ElevatedButton(
                              onPressed: (nameController.text.isNotEmpty &&
                                  selectedRole.isNotEmpty)
                                  ? () async {
                                await storeDataToFirestore();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BabyInfoPage()),
                                );
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16),
                                backgroundColor: (nameController.text.isNotEmpty &&
                                    selectedRole.isNotEmpty)
                                    ? Colors.purple.shade300
                                    : Colors.grey,
                              ),
                              child: Icon(Icons.arrow_forward, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Gradient Background Painter
class GradientBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: [
        Color(0xFFFFF4DE),
        Color(0xFF8B3A3A)
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = Path();
    path.moveTo(size.width, size.height * 0.3);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Role Button
class RoleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final Color borderColor;

  RoleButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.purple.shade400),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16, color: Colors.purple.shade400)),
          ],
        ),
      ),
    );
  }
}


