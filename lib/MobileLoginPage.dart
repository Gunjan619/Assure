import 'package:assure/Home.dart';
import 'package:assure/Services/otp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class BabyCareWelcomeScreen extends StatelessWidget {
  final _phoneNumberController = TextEditingController();

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
                        'Images/logo2.png', // Replace with your image path
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
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                  ),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  mobilelogin(context, _phoneNumberController.text);
                  // Handle Google Sign In
                },
                // icon: Image.asset(
                //   'assets/images/google_icon.png', // You can download and add a Google icon here
                //   height: 24,
                //   width: 24,
                // ),
                label: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.white, // Button background color
                  // onPrimary: Colors.black, // Text color
                  side: BorderSide(color: Colors.grey), // Border color
                ),
              ),


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
  Future<void> _makeApiRequest(String phoneNumber, BuildContext context) async {
    try {

      final url=dotenv.env["BACKEND_URL"];
      final response = await http.post(
        Uri.parse('$url/api/mobile-auth/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: '{"mobile": "$phoneNumber"}', // Replace with actual phone number
      );
      print(response.body);


      if (response.statusCode == 200) {
        // Request successful, handle the response data
        print('API request successful: ${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CodeVerificationScreen()),
        );
      } else {
        // Request failed, handle the error
        // use response.body to read error message and show to user as required
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error during API request: $e');
    }
  }
  void mobilelogin(BuildContext context, String phoneNumber) {
    _makeApiRequest(phoneNumber, context); // You might want to pass the phoneNumber to this function

    
  }
}
