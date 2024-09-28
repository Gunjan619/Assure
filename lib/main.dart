import 'package:assure/firebase_options.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2193b0), // Start color (Teal)
              Color(0xFF6dd5ed), // End color (Light Blue)
            ],
          ),
        ),
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
              const SizedBox(height: 20),

              const SizedBox(height: 10),
              // Optional loading text
              // const Text(
              //   'Loading...',
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set indicator color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
