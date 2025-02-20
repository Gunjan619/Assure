import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AskQuestionPage extends StatefulWidget {
  const AskQuestionPage({Key? key}) : super(key: key);

  @override
  State<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addQuestion() async {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('questions').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("✅ Question Added Successfully!");
        Navigator.pop(context); // Go back to Forum Page
      } catch (e) {
        print("❌ Error Adding Question: $e");
      }
    } else {
      print("⚠️ Title or Description is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask a Question"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Enter the Title",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Enter the Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.send),
                label: const Text("Post Question"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
