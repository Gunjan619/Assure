import 'package:flutter/material.dart';

class BabyDietScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          CustomPaint(
            size: Size(double.infinity, MediaQuery.of(context).size.height),
            painter: GradientPainter(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 60), // Adjusted height for top space

                  // Logo and title section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'Images/logo2.png', // Your logo image asset path
                        height: 60,
                      ),

                    ],
                  ),
                  SizedBox(height: 40),

                  // Align text and image in a row with different positioning
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food bowl image slightly to the left
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'Images/Food.png', // Replace with actual image asset
                          height: 100,
                        ),
                      ),
                      // Text aligned slightly to the right
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Let's learn about your baby's diet!",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right, // Adjusting to align more right
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40),

                  // First input field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Does your baby have any food allergies or dietary restrictions?",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Eg. Dairy, peanut, sugar",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Second input field (Choices)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Has your baby started eating solid foods?",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Choice: Yes/No/Planning to start soon",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Third input field (Choices)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Does your family follow any specific dietary preference?",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Choice: Vegetarian/Non-Vegetarian/Vegan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("Prev"),
                        style: TextButton.styleFrom(
                          iconColor: Colors.blue,
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Continue"),
                        style: ElevatedButton.styleFrom(
                          iconColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
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

// Custom gradient painter
class GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: [
        Color(0xFFFFF4DE), // Light peach color (top-left)
        Color(0xFFEEC6A6), // Light orange shade (bottom-right)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    path.moveTo(0, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
