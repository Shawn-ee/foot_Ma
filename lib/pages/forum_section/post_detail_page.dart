import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'comment.dart';

class PostDetailPage extends StatelessWidget {

  final String title;
  final String content;
  final String imageUrl;


  PostDetailPage({required this.title, required this.content, this.imageUrl = ''});
  TextEditingController commentController = TextEditingController();

  void submitComment(String postId) {
    String commentText = commentController.text.trim();
    if (commentText.isNotEmpty) {
      FirebaseFirestore.instance.collection('comments').add({
        'postId': postId, // Replace with actual post ID
        'content': commentText,
        'timestamp': FieldValue.serverTimestamp(),
        // Add other fields like userId, username, etc.
      }).then((value) {
        commentController.clear();
      }).catchError((error) {
        print("Failed to add comment: $error");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          // Image at the top
          if (imageUrl.isNotEmpty)
            Image.network(imageUrl, fit: BoxFit.cover),

          // Title and Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(content, style: TextStyle(fontSize: 16)), // Display the content
                  SizedBox(height: 20),
                  Text("Comments Section Placeholder", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                  // Here you will add your comments section logic
                ],
              ),
            )

          ),

          // Comments section
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('comments')
                  .where('postId', isEqualTo: title) // Adjust as per your data model
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error loading comments"));
                }

                // Check if snapshot data is not null before accessing docs
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No comments yet"));
                }

                List<Comment> comments = snapshot.data!.docs
                    .map((doc) => Comment.fromFirestore(doc))
                    .toList();
                print(comments);

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(comments[index].content),
                      // Add more details like username, timestamp, etc.
                    );
                  },
                );
              },
            )
          ),

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.thumb_up), onPressed: () {/* Like action */}),
            IconButton(icon: Icon(Icons.comment), onPressed: () {/* Comment action */}),
            IconButton(icon: Icon(Icons.share), onPressed: () {/* Share action */}),
          ],
        ),
      ),
    );
  }
}
