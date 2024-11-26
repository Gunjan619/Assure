import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'package:firebase_core/firebase_core.dart';
import 'package:assure/Basic%20Info/2nd.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
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
      // Reference Firestore and add data
      await FirebaseFirestore.instance.collection('users').add({
        'name': nameController.text,
        'role': selectedRole,
        'timestamp': FieldValue.serverTimestamp(), // To store the creation time
      });
      print("Data successfully stored in Firestore!");
    } catch (e) {
      print("Error storing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures screen resizes when the keyboard appears
      body: Stack(
        children: [
          // Custom painter with gradient sloping from right to left
          CustomPaint(
            size: Size(double.infinity, MediaQuery.of(context).size.height),
            painter: GradientBoxPainter(),
          ),
          SingleChildScrollView(
            // Allows scrolling when the keyboard is visible
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
                        height: 60,
                      ),
                      SizedBox(width: 8), // Small gap between logo and text
                    ],
                  ),
                  SizedBox(height: 40),
                  // Welcome text
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Subtitle
                  Text(
                    "Let's start by learning a little about you.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5A5A5A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  // Avatar upload section
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFBB86FC),
                    child: ClipOval(
                      child: Image.asset(
                        'Images/Avatar.png', // Add your avatar image here
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 30),
                  // Name input field
                  TextField(
                    controller: nameController, // Connect controller to TextField
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
                        borderSide:
                        BorderSide(color: Colors.purple.shade400),
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
                  SizedBox(height: 20),
                  // Page indicator and next button
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
                          // Store data in Firebase Firestore
                          await storeDataToFirestore();

                          // Navigate to the next page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BabyInfoPage()),
                          );
                        }
                            : null, // Disable button if no role or name is provided
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
        ],
      ),
    );
  }
}

// Custom Painter to draw gradient with a right-to-left slope
class GradientBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: [
        Color(0xFFFFF4DE),
        Color(0xFFEEC6A6),
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
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 30, color: Colors.purple.shade400),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
