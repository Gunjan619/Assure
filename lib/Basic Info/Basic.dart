import 'package:flutter/material.dart';
import 'package:assure/Basic%20Info/2nd.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selectedRole = ''; // To store the selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures screen resizes when the keyboard appears
      body: Stack(
        children: [
          // Custom painter with gradient sloping from right to left
          CustomPaint(
            size: Size(double.infinity, MediaQuery.of(context).size.height),
            painter: GradientBoxPainter(), // Updated gradient colors
          ),
          SingleChildScrollView( // Wrap with SingleChildScrollView to allow scrolling when keyboard is visible
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
                        height: 60, // Adjusted to match reference design
                      ),
                      SizedBox(width: 8), // Small gap between logo and text
                    ],
                  ),
                  SizedBox(height: 40),
                  // Welcome text
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28, // Adjusted font size
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333), // Darker shade of gray
                    ),
                  ),
                  SizedBox(height: 10),
                  // Subtitle
                  Text(
                    "Let's start by learning a little about you.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5A5A5A), // Slightly darker gray for a subtle look
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  // Avatar upload section
                  CircleAvatar(
                    radius: 60, // Increased size for the avatar
                    backgroundColor: Color(0xFFBB86FC), // Brighter purple
                    child: ClipOval(
                      child: Image.asset(
                        'Images/Avatar.png', // Add your avatar image here
                        width: 90, // Adjusted width
                        height: 90,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 30),
                  // Name input field
                  TextField(
                    cursorColor: Colors.black, // Set the cursor color to black
                    decoration: InputDecoration(
                      labelText: "What's your name?",
                      labelStyle: TextStyle(color: Colors.black54),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12), // Increased padding
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16), // Rounded corners
                        borderSide: BorderSide(color: Colors.grey.shade300), // Light border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.purple.shade400), // Purple outline when focused
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
                            ? Color(0xFFBB86FC) // Brighter purple for selection
                            : Color(0xFFFFE0E0), // Light coral when not selected
                        borderColor: selectedRole == 'Father'
                            ? Colors.white // White border when selected
                            : Colors.transparent, // No border when not selected
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
                            ? Color(0xFFBB86FC) // Brighter purple for selection
                            : Color(0xFFFFE0E0), // Light coral when not selected
                        borderColor: selectedRole == 'Mother'
                            ? Colors.white // White border when selected
                            : Colors.transparent, // No border when not selected
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Added some space before the footer row
                  // Page indicator and next button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Empty space to balance the layout
                      SizedBox(width: 40),

                      // Centered '1 of 3' text
                      Text(
                        '1 of 3',
                        style: TextStyle(color: Colors.black54),
                      ),

                      // Next button aligned to the right
                      ElevatedButton(
                        onPressed: selectedRole.isNotEmpty
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BabyInfoPage()),
                          );
                        }
                            : null, // Disable button if no role is selected
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                          backgroundColor: selectedRole.isNotEmpty
                              ? Colors.purple.shade300 // Lighter purple for active state
                              : Colors.grey, // Grey color for inactive state
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
    // Define gradient colors
    final Gradient gradient = LinearGradient(
      colors: [
        Color(0xFFE6B3FF), // Lighter lavender
        Color(0xFFFFE0E0), // Light coral
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

    // Create a paint object with the gradient
    final Paint paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create the path for the diagonal slope
    Path path = Path();
    path.moveTo(size.width, size.height * 0.3); // Lower slope point
    path.lineTo(0, size.height * 0.6); // Slope to the middle-left
    path.lineTo(0, 0); // Top-left corner
    path.lineTo(size.width, 0); // Top-right corner
    path.close();

    // Draw the gradient path
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
  final Color color; // Add color parameter for custom color
  final Color borderColor; // Add borderColor parameter for custom border color

  RoleButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color, // Initialize the custom color
    required this.borderColor, // Initialize the custom border color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color, // Use the passed color
          borderRadius: BorderRadius.circular(16), // Rounded corners
          border: Border.all(
            color: borderColor, // Use the passed border color
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
            // Change the text color based on selection
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color:  Colors.purple.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
