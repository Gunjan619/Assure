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

  Future<User?> _signInWithGoogle(BuildContext context) async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print("Error loading .env file: $e");
    }

    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut(); // Clear the default account to force account selection

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

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

          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          return userCredential.user;
        } else {
          print('Error sending user data to backend: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Backend error")),
          );
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed")),
      );
    }
    return null;
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
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Image.asset(
                    'Images/logo2.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 30),

            // Illustration section
            Image.asset(
              'Images/openImage.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            // Google Sign-in button
            GestureDetector(
              onTap: () async {
                User? user = await _signInWithGoogle(context);
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
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
                      height: 40,
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