import 'package:assure/Basic%20Info/Basic.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MobileLoginPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  Future<User?> _signInWithGoogle() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print(e);
    }
    try {
      // Create a GoogleSignIn object
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      // Clear the default account to force account selection
      await _googleSignIn.signOut();

      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the Google authentication details
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final url = dotenv.env['BACKEND_URL'];
        final response = await http.post(
          Uri.parse('$url/api/google-login/'),
          body: {
            "token": googleAuth.idToken,
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final authToken = responseData['token'];
          
          final storage = FlutterSecureStorage();
          await storage.write(key: 'authToken', value: authToken);
          // // Proceed with navigation or other actions
          // Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(builder: (context) => WelcomeScreen()),
          //         );
        } else {
          // Handle backend request error
          print('Error sending user data to backend: ${response.statusCode}');
          // // Display an error message to the user
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Backend error")),
          // );
        }
        
        // Sign in to Firebase with the Google credential
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo section
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,  // Full width of the screen
                  height: 150,  // Adjust the height as per your preference
                  child: Image.asset(
                    'Images/logo2.png', // Replace with your image path
                    fit: BoxFit.contain,  // Contain ensures the image fits within the given width and height while maintaining its aspect ratio
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 30),

            // Illustration section
            Image.asset(
              'Images/openImage.png', // Replace with your illustration image
              width: 250, // Adjust based on the image size
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            // Google Sign-in button
            GestureDetector(
              onTap: () async {
                User? user = await _signInWithGoogle();
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                } else {
                  // Handle sign-in failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Google sign-in failed")),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const SizedBox(width: 15),
                    Image.asset(
                      'Images/continue_with_google.png',
                      height: 40, // Adjust the height as needed
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Mobile number sign-in option
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BabyCareWelcomeScreen()),
                );
              },
              child: const Text(
                'or continue with Mobile Number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}