import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '3rd.dart';

class BabyInfoPage extends StatefulWidget {
  const BabyInfoPage({Key? key}) : super(key: key);

  @override
  _BabyInfoPageState createState() => _BabyInfoPageState();
}

class _BabyInfoPageState extends State<BabyInfoPage> {
  DateTime? _selectedDate;
  final TextEditingController _babyNameController = TextEditingController();
  final TextEditingController _babyWeightController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedGender;
  String? _parentName = "Parent"; // Default value before fetching the data

  @override
  void initState() {
    super.initState();
    _fetchParentName(); // Fetch parent name from Firebase when the page loads
  }

  Future<void> _fetchParentName() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return;
      }

      // Fetch the user document from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Ensure this matches your Firestore collection name
          .doc(user.uid) // Use the current user's UID
          .get();

      if (userDoc.exists) {
        setState(() {
          _parentName = userDoc['name'] ?? "Parent"; // Fetch the 'name' field
        });
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      // Handle errors (e.g., network issues, permission issues)
      print("Error fetching parent name: $e");
    }
  }

  // Function to store baby's information in Firestore
  Future<void> _storeBabyInfo() async {
    try {
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is logged in.");
        return;
      }

      // Prepare the data to be stored
      Map<String, dynamic> babyData = {
        'babyName': _babyNameController.text.trim(),
        'babyGender': _selectedGender,
        'babyWeight': _babyWeightController.text.trim(),
        'babyDOB': _selectedDate,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      };

      // Store the data in Firestore
      await FirebaseFirestore.instance
          .collection('users') // Parent collection
          .doc(user.uid) // User's document
          .collection('babyInfo') // Subcollection for baby's information
          .add(babyData); // Add a new document with baby's data

      print("Baby's information successfully stored in Firestore!");
    } catch (e) {
      print("Error storing baby's information: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with Gradient Background
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF67E7D), Color(0xFFF8A16D)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    const SizedBox(height: 20),
                // Logo with Shadow
                Container(

                child: Image.asset(
                  'Images/logo2.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 20),
              // Welcome Message
              Text(
                'Hello, $_parentName!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333)),
              ),
              const SizedBox(height: 10),
              // Description Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
                )
                ],
              ),
              child: Text(
                'Parenting is a journey of love, growth, and discovery. '
                    'Welcome to your partner in this beautiful adventure.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown),
              ),
            ),
          ],
        ),
      ),
    ),

    // Form Fields and Buttons
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    const SizedBox(height: 20),
    Text(
    'Tell us about your baby',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF5A5A5A)),
    ),
    const SizedBox(height: 20),

    // Baby Name Input Field
    TextFormField(
    controller: _babyNameController,
    decoration: InputDecoration(
    labelText: 'What should we call your baby?',
    prefixIcon: Icon(Icons.child_care, color: Colors.purple),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
    color: Color(0xFFBB86FC),
    width: 2),
    ),
    ),
    ),
    const SizedBox(height: 20),

    // Gender Selection
    Text(
    'What is your baby gender?',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 10),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    GenderButton(
    text: 'Boy',
    isSelected: _selectedGender == 'Boy',
    onPressed: () {
    setState(() {
    _selectedGender = 'Boy';
    });
    },
    ),
    GenderButton(
    text: 'Girl',
    isSelected: _selectedGender == 'Girl',
    onPressed: () {
    setState(() {
    _selectedGender = 'Girl';
    });
    },
    ),
    GenderButton(
    text: 'Other',
    isSelected: _selectedGender == 'Other',
    onPressed: () {
    setState(() {
    _selectedGender = 'Other';
    });
    },
    ),
    ],
    ),
    const SizedBox(height: 20),

    // Baby Weight Input Field
    TextFormField(
    controller: _babyWeightController,
    decoration: InputDecoration(
    labelText: 'How much does your baby weigh?',
    prefixIcon: Icon(Icons.scale, color: Colors.purple),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
    color: Color(0xFFBB86FC),
    width: 2),
    ),
    hintText: 'e.g. 1.5 Kg',
    ),
    ),
    const SizedBox(height: 20),

    // Baby Date of Birth Picker
    GestureDetector(
    onTap: () {
    _selectDate(context);
    },
    child: AbsorbPointer(
    child: TextFormField(
    controller: _dateController,
    decoration: InputDecoration(
    labelText: 'When was your baby born?',
    prefixIcon: Icon(Icons.calendar_month, color: Colors.purple),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
    color: Color(0xFFBB86FC),
    width: 2),
    ),
    hintText: 'Select Date',
    ),
    ),
    ),
    ),
    const SizedBox(height: 20),
    ],
    ),
    ),

    // Bottom Navigation Buttons
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    TextButton(
    onPressed: () {
    // Logic for Previous Button
    },
    child: Text(
    'Prev',
    style: TextStyle(
    fontSize: 16,
    color: Colors.blue),
    ),
    ),
    Text('2 of 3', style: TextStyle(color: Colors.black54)),
    ElevatedButton(
    onPressed: () async {
    if (_babyNameController.text.isNotEmpty &&
    _babyWeightController.text.isNotEmpty &&
    _selectedDate != null &&
    _selectedGender != null) {
    // Save baby's information to Firestore
    await _storeBabyInfo();

    // Navigate to the next screen
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => BabyDietScreen()),
    );
    } else {
    // Show error message if any field is empty
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Please fill in all fields')),
    );
    }
    },
    style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: Colors.purple.shade300,
    ),
    child: Text(
    'Next',
    style: TextStyle(color: Colors.white, fontSize: 18),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    );
  }

  // Date Picker Function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }
}

// Gender Button Widget
class GenderButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const GenderButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFFBB86FC) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.purple),
      ),
    );
  }
}