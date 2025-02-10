import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send a message
  Future<void> sendMessage(String receiverID, String messageText) async {
    final String? currentUserId = _auth.currentUser?.uid;
    final String? currentUserEmail = _auth.currentUser?.email;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderID: currentUserId!,
      senderEmail: currentUserEmail!,
      receiverID: receiverID,
      message: messageText,
      timestamp: timestamp,
    );

    // Construct chat room for two users to ensure uniqueness
    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Add new message to the Firestore database
    await _firestore.collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages stream
  Stream<List<Message>> getMessagesStream(String chatRoomId) {
    return _firestore.collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }
}
