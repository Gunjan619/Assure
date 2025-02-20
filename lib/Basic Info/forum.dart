import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bottom_navigator.dart';
import 'ask_question.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  TextEditingController _commentController = TextEditingController();
  String? selectedQuestionId;

  void postComment(String questionId) async {
    if (_commentController.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('questions').doc(questionId).collection('comments').add({
      'text': _commentController.text,
      'timestamp': Timestamp.now(),
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Color(0xFFFCE5C0),
      appBar: AppBar(
        title: const Text("Forum", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFFFCE5C0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('questions').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty_rounded, color: Colors.grey, size: 50),
                    SizedBox(height: 10),
                    Text("No Data to Show", style: TextStyle(fontSize: 18, color: Colors.black54)),
                  ],
                ),
              );
            }

            var questions = snapshot.data!.docs;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var question = questions[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedQuestionId = question.id;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['title'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          question['description'],
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.black),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.black),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever_rounded, color: Colors.black),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('questions').doc(question.id).delete();
                              },
                            ),
                          ],
                        ),
                        if (selectedQuestionId == question.id) ...[
                          StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('questions').doc(question.id).collection('comments').orderBy('timestamp', descending: true).snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> commentSnapshot) {
                              if (!commentSnapshot.hasData || commentSnapshot.data!.docs.isEmpty) {
                                return const Text("No comments yet", style: TextStyle(color: Colors.black54));
                              }

                              return Column(
                                children: commentSnapshot.data!.docs.map((comment) {
                                  return Card(
                                    color: Colors.grey[200],
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(comment['text'], style: TextStyle(color: Colors.black)),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: "Add a comment...",
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send, color: Colors.black),
                                  onPressed: () => postComment(question.id),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AskQuestionPage()));
        },
        label: const Text("ASK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        icon: const Icon(Icons.add),
        backgroundColor: Color(0xFF7B5DB1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
