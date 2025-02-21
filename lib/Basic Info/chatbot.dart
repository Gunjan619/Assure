import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../bottom_navigator.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [
    {"sender": "user", "message": "Hi there"},
    {"sender": "bot", "message": "How can I help you?"},
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({"sender": "user", "message": _controller.text});
      });

      final url = dotenv.env['BACKEND_URL'];
      final storage = FlutterSecureStorage();
      final authToken = await storage.read(key: 'authToken');
      if (url != null && authToken != null) {
        try {
          final response = await http.post(
            Uri.parse('$url/api/chat-bot/'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $authToken',
            },
            body: jsonEncode({
              'message': _controller.text,
            }),
          );
          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            setState(() {
              messages.add({"sender": "bot", "message": responseData['reply']});
            });
          } else {
            print("Failed to get response from the backend: ${response.statusCode}");
          }
        } catch (e) {
          print("Error sending message to the backend: $e");
        }
      } else {
        print("Backend URL or auth token is not set.");
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8A16D), // Orange background
      appBar: AppBar(
        backgroundColor: Color(0xFFFCEEC1), // Light beige
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Chat Bot",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFFFCEEC1) : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isUser) Icon(Icons.auto_awesome, size: 16, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          message["message"]!,
                          style: TextStyle(fontSize: 16),
                        ),
                        if (isUser) ...[
                          SizedBox(width: 5),
                          Icon(Icons.person, color: Colors.black),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF9CBA5), // Light orange
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Send", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
