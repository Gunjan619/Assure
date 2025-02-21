import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class Memo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemoriesScreen(),
    );
  }
}

class MemoriesScreen extends StatefulWidget {
  @override
  _MemoriesScreenState createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  File? _selectedImage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addMemory() async {
    if (_titleController.text.isEmpty || _dateController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image")),
      );
      return;
    }

    // Upload image to Firebase Storage (optional) and get the URL
    // For now, we'll just store the local file path
    String imagePath = _selectedImage!.path;

    // Add memory data to Firestore
    await _firestore.collection('memories').add({
      'title': _titleController.text,
      'date': _dateController.text,
      'imagePath': imagePath,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the form
    _titleController.clear();
    _dateController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF4DE), // Soft Cream Background
      appBar: AppBar(
        title: const Text("Memories", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFFF67E7D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('memories').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final memory = doc.data() as Map<String, dynamic>;
                      return memoryTile(memory['title'], memory['date'], memory['imagePath']);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Memory"),
                content: SingleChildScrollView( // Make the dialog scrollable
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(hintText: "Title"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _dateController,
                        decoration: InputDecoration(hintText: "Date"),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: memoryFrame(image: _selectedImage),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      _addMemory();
                      Navigator.pop(context);
                    },
                    child: Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Color(0xFF6C3A82), // Purple Button
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget memoryTile(String title, String date, String imagePath) {
    return Card(
      elevation: 4, // Shadow for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 12),
            memoryFrame(image: File(imagePath)),
          ],
        ),
      ),
    );
  }

  Widget memoryFrame({File? image}) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFFC977ED), Color(0xFFF8A16D)], // Gradient Colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: image != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(image, fit: BoxFit.cover),
      )
          : Center(
        child: Text(
          "Upload Image",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}