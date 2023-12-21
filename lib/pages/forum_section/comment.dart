// comment.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String postId;
  String userId;
  String content;
  DateTime timestamp;

  Comment({required this.id, required this.postId, required this.userId, required this.content, required this.timestamp});

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
