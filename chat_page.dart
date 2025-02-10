import 'package:chat_application/auth_service.dart';
import 'package:chat_application/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({super.key, required this.receiverEmail, required this.receiverID, required String recieverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  String? _chatRoomId;

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  /// Initializes the chat room ID to avoid re-calculating it multiple times.
  Future<void> _initializeChatRoom() async {
    String? currentUserId = await _getCurrentUserId();
    if (currentUserId != null) {
      List<String> ids = [currentUserId, widget.receiverID];
      ids.sort();
      setState(() {
        _chatRoomId = ids.join("_");
      });
    }
  }

  /// Fetches the current user's ID.
  Future<String?> _getCurrentUserId() async {
    User? user = await _authService.getCurrentUser();
    return user?.uid;
  }

  /// Sends a message and updates the UI immediately.
  void sendMessage() async {
    if (_textEditingController.text.isNotEmpty && _chatRoomId != null) {
      String messageText = _textEditingController.text;
      _textEditingController.clear();  // Clear input before sending
      setState(() {}); // Force UI update

      await _chatService.sendMessage(widget.receiverID, messageText);
    }
  }

  /// Builds the message list using Firestore real-time updates.
  Widget _buildMessageList() {
    if (_chatRoomId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessagesStream(_chatRoomId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        var messages = snapshot.data!;
        return ListView.builder(
          reverse: true, // Show newest messages at the bottom
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index];
            bool isCurrentUserSender = message.senderEmail == _authService.getCurrentUser()?.email;

            return Align(
              alignment: isCurrentUserSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: isCurrentUserSender ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: isCurrentUserSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isCurrentUserSender ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message.timestamp.toDate().toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Center(child: Text('Chat with ${widget.receiverEmail}', style: const TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold
        ),)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Future<User?> {
  Object? get email => null;
}
