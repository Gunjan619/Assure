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
      extendBodyBehindAppBar: true, // Allows gradient to extend behind AppBar
      appBar: AppBar(
        backgroundColor: Color(0xFFFCEEC1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ✅ Goes back to the previous page
          },
        ),
        title: Text(
          "Chat Bot",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF67E7D), Color(0xFFF8A16D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 16, right: 16, top: 90, bottom: 20),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message["sender"] == "user";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUser ? Color(0xFFFCEEC1) : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: isUser ? Radius.circular(20) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isUser)
                            Icon(Icons.smart_toy, size: 18, color: Colors.white70),
                          SizedBox(width: 6),
                          Text(
                            message["message"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: isUser ? Colors.black87 : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isUser) ...[
                            SizedBox(width: 6),
                            Icon(Icons.person, color: Colors.black87),
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
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: sendMessage,
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.purple,
                      child: Icon(Icons.send, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
