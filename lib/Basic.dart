import 'package:flutter/material.dart';

const kSpacing = 16.0;
const kPrimaryColor = Color(0xFFE044B9);
const kSecondaryColor = Color(0xFFF7A15F);
const kTextColor = Colors.black; // Darker color for better contrast

class BasicInformationPage extends StatefulWidget {
  const BasicInformationPage({Key? key}) : super(key: key);

  @override
  State<BasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,  // Ensure the container takes the full height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor, kSecondaryColor],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kSpacing),
                  Center(
                    child: Column(
                      children: [
                        // Adding the logo above the avatar
                        Container(
                          width: MediaQuery.of(context).size.width,  // Full width of the screen
                          height: 150,  // Adjust the height as per your preference
                          child: Image.asset(
                            'Images/logo.png', // Replace with your image path
                            fit: BoxFit.contain,  // Contain ensures the image fits within the given width and height while maintaining its aspect ratio
                          ),
                        ),
                        const SizedBox(height: kSpacing),
                        CircleAvatar(
                          radius: 80.0,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'Images/Avatar.jpg',
                              fit: BoxFit.cover, // Ensures the avatar fits the circle
                              width: 160.0,
                              height: 160.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpacing),

                  const SizedBox(height: kSpacing * 2),
                  Text(
                    'What is your full name?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: kSpacing),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.42),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                  const SizedBox(height: kSpacing),
                  Text(
                    'Who are you?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: kSpacing),
                  DropdownButtonFormField<String>(
                    value: selectedValue,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Father',
                        child: Text('Father'),
                      ),
                      DropdownMenuItem(
                        value: 'Mother',
                        child: Text('Mother'),
                      ),
                    ],
                    decoration: InputDecoration(
                      fillColor: Colors.white.withOpacity(0.42),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
