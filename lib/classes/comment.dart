import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String firstName;
  final String comment;
  final double rate;
  final DateTime time;

  Comment({
    required this.firstName,
    required this.comment,
    required this.rate,
    required this.time,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['time'] as Timestamp; // Firestore Timestamp
    DateTime dateTime = timestamp.toDate(); // Convert to DateTime

    return Comment(
      firstName: data['first_name'] ?? '',
      comment: data['comment'] ?? '',
      rate: (data['rate'] is int) ? (data['rate'] as int).toDouble() : data['rate'] as double,
      time: dateTime, // Now it's a DateTime object
    );
  }


}
