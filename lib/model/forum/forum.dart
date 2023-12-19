import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  String id;
  String title;
  String content;
  String userId;
  String username;

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.username,
  });

  factory ForumPost.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ForumPost(
      id: doc.id, // Assuming the document ID is the post ID
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
