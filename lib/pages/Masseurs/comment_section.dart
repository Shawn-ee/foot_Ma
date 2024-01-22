// comments_section.dart
import 'package:flutter/material.dart';
import 'package:chatapp_firebase/classes/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../service/storage_function/storage.dart';
class CommentsList extends StatelessWidget {
  final FileStorageService storageService = FileStorageService();
  final String masseurId;

  CommentsList({Key? key, required this.masseurId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: storageService.fetchComments(masseurId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Comment> comments = snapshot.data!;
          return Column(
            children: comments.map((Comment comment) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
// Replace with NetworkImage if you have the image URL
//                       backgroundImage: AssetImage('path/to/masseur_image.png'),
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.firstName, // Display the user's first name
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, // Bold username
                                ),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd – kk:mm').format(comment.time), // Format the timestamp
                                style: TextStyle(fontSize: 12, color: Colors.grey), // Smaller, grey timestamp
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(comment.comment), // Display the comment text
                          SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < comment.rate ? Icons.star : Icons.star_border,
                                color: starIndex < comment.rate ? Colors.amber : Colors.grey,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return Center(child: Text('No comments found'));
        }
      },
    );
  }
}

