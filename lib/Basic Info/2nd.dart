import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BabyInfoPage extends StatefulWidget {
  const BabyInfoPage({Key? key}) : super(key: key);

  @override
  _BabyInfoPageState createState() => _BabyInfoPageState();
}

class _BabyInfoPageState extends State<BabyInfoPage> {
  DateTime? _selectedDate;
  final TextEditingController _babyNameController = TextEditingController();
  final TextEditingController _babyWeightController = TextEditingController();

  String? _selectedGender; // New variable to track selected gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD1DC), // Set a matching light pink background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Image.asset('Images/logo2.png', height: 50), // Logo in the AppBar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Hello, Parent!',
                style: TextStyle(
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
                      offset: Offset(0, 3),
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

              // Gender Selection
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
                      hintText: _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Next Button
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
                    // Navigate to the next page or perform any action needed
                  } else {
                    // Handle error for invalid input
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Color(0xFFBB86FC), // Match to WelcomeScreen
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class GenderButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed; // New parameter for button action

  const GenderButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Call the function passed from the parent
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFBB86FC) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
