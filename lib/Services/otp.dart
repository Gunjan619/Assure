import 'package:assure/Basic%20Info/Basic.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CodeVerificationScreen extends StatefulWidget {
  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  // List of TextEditingControllers for each TextField
String? phoneNumber; // Variable to store phone number

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get the arguments passed from the previous page
    phoneNumber = ModalRoute.of(context)?.settings.arguments as String; 
  }
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  // List of FocusNodes for each TextField
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _moveToNextField(int index) {
    if (index < _focusNodes.length - 1) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _moveToPreviousField(int index) {
    if (index > 0) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

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
                width: MediaQuery.of(context)
                    .size
                    .width, // Full width of the screen
                height: 150, // Adjust the height as per your preference
                child: Image.asset(
                  'Images/logo2.png', // Replace with your image path
                  fit: BoxFit
                      .contain, // Contain ensures the image fits within the given width and height while maintaining its aspect ratio
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
                    width: 50, // Width of each TextField
                    height: 60, // Height of each TextField
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.black),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText:
                              "", // Removes the character count indicator
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _moveToNextField(index);
                          } else if (value.isEmpty && index > 0) {
                            _moveToPreviousField(index);
                          }
                        },
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
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    String otp = _controllers
                        .map((controller) => controller.text)
                        .join();
                    final url = dotenv.env["BACKEND_URL"];
                    final response = await http.post(
                      Uri.parse(
                          '$url/api/mobile-auth/verify_otp/'), // Replace with your actual API endpoint
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        'otp': otp,
                        'mobile': phoneNumber ?? '',
                      }),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    if (response.statusCode == 200) {
                      // OTP verification successful
                      final responseData = jsonDecode(response.body);
                      final authToken = responseData['token'];

                      final storage = FlutterSecureStorage();
                      await storage.write(key: 'authToken', value: authToken);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                      );
                    } else {
                      // OTP verification failed
                      print(response.body);
                      Fluttertoast.showToast(
                        msg: "Incorrect OTP. Please try again.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
// Suggested code may be subject to a license. Learn more: ~LicenseLog:82847396.
                    }
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
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
