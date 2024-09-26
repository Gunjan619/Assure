import 'package:assure/Home.dart';
import 'package:flutter/material.dart';

class BabyCareWelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the custom logo
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,  // Full width of the screen
                      height: 150,  // Adjust the height as per your preference
                      child: Image.asset(
                        'Images/logo.png', // Replace with your image path
                        fit: BoxFit.contain,  // Contain ensures the image fits within the given width and height while maintaining its aspect ratio
                      ),
                    ),
                    SizedBox(height: 10),

                  ],
                ),
              ),
              SizedBox(height: 20),

              // Image of mother and child
              Image.asset(
                'Images/openImage.png', // Add your image here
                height: 250,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 20),

              // Mobile Number Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Sign In with Google button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                  // Handle Google Sign In
                },
                // icon: Image.asset(
                //   'assets/images/google_icon.png', // You can download and add a Google icon here
                //   height: 24,
                //   width: 24,
                // ),
                label: Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.white, // Button background color
                  // onPrimary: Colors.black, // Text color
                  side: BorderSide(color: Colors.grey), // Border color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
