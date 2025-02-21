import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Home_main.dart';

class BabyDietScreen extends StatefulWidget {
  @override
  _BabyDietScreenState createState() => _BabyDietScreenState();
}

class _BabyDietScreenState extends State<BabyDietScreen> {
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _solidFoodController = TextEditingController();
  final TextEditingController _dietPreferenceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _storeDietInfo(BuildContext context) async {
    if (_allergiesController.text.isEmpty ||
        _solidFoodController.text.isEmpty ||
        _dietPreferenceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return;
      }

      Map<String, dynamic> dietData = {
        'allergies': _allergiesController.text.trim(),
        'solidFood': _solidFoodController.text.trim(),
        'dietPreference': _dietPreferenceController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('dietInfo')
          .add(dietData);

      print("Diet information successfully stored in Firestore!");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home_main()),
      );
    } catch (e) {
      print("Error storing diet information: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data. Please try again.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // IMPORTANT: Ye keyboard se overlap hone ka issue fix karega
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: GradientPainter(),
                ),
              ),
              SingleChildScrollView( // Wrap everything inside this
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60),
                      Center(
                        child: Image.asset(
                          'Images/logo2.png',
                          height: 60,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              'Images/Food.png',
                              height: 100,
                            ),
                          ),
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
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Does your baby have any food allergies or dietary restrictions?",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _allergiesController,
                        decoration: InputDecoration(
                          hintText: "Eg. Dairy, peanut, sugar",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Has your baby started eating solid foods?",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _solidFoodController,
                        decoration: InputDecoration(
                          hintText: "Choice: Yes/No/Planning to start soon",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Does your family follow any specific dietary preference?",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _dietPreferenceController,
                        decoration: InputDecoration(
                          hintText: "Choice: Vegetarian/Non-Vegetarian/Vegan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text("Prev"),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(fontSize: 18),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                              _storeDietInfo(context);
                            },
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("Continue"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = LinearGradient(
      colors: [
        Color(0xFFFFF4DE),  // Light Cream
        Color(0xFFEEC6A6),  // Soft Peach
        Color(0xFFD89A74),  // Warm Sand (for depth)
        Color(0xFF8B3A3A),
        Color(0xFFF67E7D), Color(0xFFF8A16D)
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