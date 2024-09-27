import 'package:flutter/material.dart';

class CodeVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,  // Full width of the screen
                height: 150,  // Adjust the height as per your preference
                child: Image.asset(
                  'Images/logo.png', // Replace with your image path
                  fit: BoxFit.contain,  // Contain ensures the image fits within the given width and height while maintaining its aspect ratio
                ),
              ),
              SizedBox(height: 16),
              Text(
                "VERIFICATION",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "Enter the verification code sent ",
                style: TextStyle(fontSize: 14),
              ),

              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,  // Width of each TextField
                    height: 60,  // Height of each TextField
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black),
                    ),
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "", // Removes the character count indicator
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56, // Increased button height
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Next button press
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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
