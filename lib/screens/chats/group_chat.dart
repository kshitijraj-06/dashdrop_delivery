import 'package:animated_flutter_widgets/animated_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';




class ChatScreen extends StatefulWidget {
  final String currentUserId;

  const ChatScreen({super.key, required this.currentUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  Color _getRandomColor(String senderId) {
    final random = Random(senderId.hashCode);
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:45.0, left: 12),
            child: Row(
              children: [
                EaseInAnimation(
                  duration: const Duration(seconds: 1),
                  child: Text(
                    'Chat & Support',
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        fontSize:24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width:50),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return _buildLoadingIndicator();
                }

                final messages = snapshot.data!.docs;

                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['text'];
                  final messageSender = message['senderId'];

                  Future<String> getSenderName() async {
                    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(messageSender)
                        .get();
                    return userSnapshot['name'] ?? 'Unknown User';
                  }

                  final messageWidget = FutureBuilder<String>(
                    future: getSenderName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final senderName = snapshot.data ?? 'Unknown User';
                      final senderColor = _getRandomColor(messageSender);

                      return MessageWidget(
                        senderId: messageSender,
                        senderName: senderName,
                        senderColor: senderColor,
                        text: messageText,
                        isCurrentUser: widget.currentUserId == messageSender,
                      );
                    },
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[200],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontSize: 15,
                              )
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(widget.currentUserId, _messageController.text);
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String senderId, String text) {
    FirebaseFirestore.instance.collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': DateTime.now(),
    });
  }
}

class MessageWidget extends StatelessWidget {
  final String senderId;
  final String senderName;
  final Color senderColor;
  final String text;
  final bool isCurrentUser;

  const MessageWidget({super.key, 
    required this.senderId,
    required this.senderName,
    required this.senderColor,
    required this.text,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust the maximum width as needed
            ),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.grey[700],
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display sender's name with a random color
                Text(
                  senderName,
                  style: TextStyle(
                    color: senderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Wrap the text to show long messages in multiple lines
                Wrap(
                  children: [
                    Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }
}

