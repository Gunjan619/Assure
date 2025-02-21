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
  String? selectedQuestionId; // Tracks the currently selected question ID

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
      backgroundColor: Color(0xFFEEC6A6),
      appBar: AppBar(
        title: const Text("Forum", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFFF67E7D),
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
                      // Toggle the comment section
                      if (selectedQuestionId == question.id) {
                        selectedQuestionId = null; // Close the comment section
                      } else {
                        selectedQuestionId = question.id; // Open the comment section
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFBE4B2), Color(0xFFF67E7D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User Name", // Replace with actual username
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                Text(
                                  "2 hours ago", // Replace with actual timestamp
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          question['title'],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          question['description'],
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.black),
                                  onPressed: () {},
                                ),
                                Text("12", style: TextStyle(color: Colors.black)), // Like count
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.thumb_down_alt_outlined, color: Colors.black),
                                  onPressed: () {},
                                ),
                                Text("2", style: TextStyle(color: Colors.black)), // Dislike count
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_forever_rounded, color: Colors.black),
                              onPressed: () async {
                                await FirebaseFirestore.instance.collection('questions').doc(question.id).delete();
                              },
                            ),
                          ],
                        ),
                        if (selectedQuestionId == question.id) ...[
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('questions')
                                .doc(question.id)
                                .collection('comments')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> commentSnapshot) {
                              if (!commentSnapshot.hasData || commentSnapshot.data!.docs.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "No comments yet",
                                    style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    child: Text(
                                      "Comments",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                  ),
                                  Divider(color: Colors.black38, thickness: 0.5),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: commentSnapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var comment = commentSnapshot.data!.docs[index];

                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(1, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.grey[400],
                                              child: Icon(Icons.person, color: Colors.white),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "User", // Replace with actual username
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    comment['text'],
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Just now", // Replace with formatted timestamp
                                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
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