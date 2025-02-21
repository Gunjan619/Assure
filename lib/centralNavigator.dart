import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'Home_main.dart';

class NavigationHandler {
  static Future<void> navigateBasedOnUserStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isNewUser = prefs.getBool('isNewUser') ?? true;

    if (isNewUser) {
      // New user flow
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } else {
      // Returning user flow
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home_main()),
      );
    }
  }

  static Future<void> completeRegistration(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNewUser', false); // Mark user as not new

    // Navigate to the next screen in the flow
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home_main()),
    );
  }
}