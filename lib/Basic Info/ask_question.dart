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
        Navigator.pop(context);
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Ask a Question", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF67E7D), Color(0xFFF8A16D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Post Your Question",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Title",
                            prefixIcon: Icon(Icons.title_rounded, color: Colors.purple),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: Icon(Icons.description_rounded, color: Colors.purple),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _addQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[800],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Post Question",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
