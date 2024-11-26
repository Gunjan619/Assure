import 'package:assure/Basic%20Info/3rd.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Example Firestore collection and document path
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Adjust the collection name
          .doc('USER_ID') // Replace with the actual user ID
          .get();

      if (userDoc.exists) {
        setState(() {
          _parentName = userDoc['name'] ?? "Parent"; // Fetch the 'name' field
        });
      }
    } catch (e) {
      // Handle errors (e.g., network issues, permission issues)
      print("Error fetching parent name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top colored background
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: const Color(0xFFFFF1C1), // Light yellow background color
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Logo
                    Image.asset(
                      'Images/logo2.png',
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    // Display fetched parent name
                    Text(
                      'Hello, $_parentName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Parenting is a journey of love, growth, and discovery. '
                            'Welcome to your partner in this beautiful adventure.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Form fields and buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Tell us about your baby',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Baby Name Input Field
                    TextFormField(
                      controller: _babyNameController,
                      decoration: InputDecoration(
                        labelText: 'What should we call your baby?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFBB86FC),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Gender Label
                    const Text(
                      'What is your baby gender?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Gender Selection Buttons
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
                          text: 'Prefer not to say',
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFBB86FC),
                            width: 2,
                          ),
                        ),
                        hintText: 'e.g. 1.5 Kg',
                        suffixIcon: Icon(Icons.scale),
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
                          controller: _dateController, // This controller will display the date
                          decoration: InputDecoration(
                            labelText: 'When was your baby born?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFBB86FC),
                                width: 2,
                              ),
                            ),
                            hintText: 'Select Date',
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
                  child: const Text(
                    'Prev',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Text('2 of 3'), // Step Indicator
                ElevatedButton(
                  onPressed: () {
                    // Add your navigation or submission logic here
                    if (_babyNameController.text.isNotEmpty &&
                        _babyWeightController.text.isNotEmpty &&
                        _selectedDate != null &&
                        _selectedGender != null) {
                      // Handle valid input
                      print('Baby Name: ${_babyNameController.text}');
                      print('Baby Weight: ${_babyWeightController.text}');
                      print('Baby Gender: $_selectedGender');
                      print('Baby Date of Birth: ${_selectedDate.toString()}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BabyDietScreen()),
                      );
                    } else {
                      // Handle error for invalid input
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        iconColor: isSelected ? const Color(0xFFBB86FC) : Colors.grey.shade200,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
