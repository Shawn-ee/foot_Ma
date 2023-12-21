import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_post_page.dart'; // Make sure this import points to your CreatePostPage file
import 'post_detail_page.dart';
import 'package:chatapp_firebase/pages/appDrawer.dart';
class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData ) {
            return Center(child: Text("No posts found"));
          }

          List<Map<String, dynamic>> posts = snapshot.data?.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList() ?? [];

          return ListView.builder(

            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              String title = post['title'] ?? 'Untitled'; // Default to 'Untitled' if null
              String content = post['content'] ?? 'No content'; // Default to 'No content' if null
              String imageUrl = post['imageUrl'] ?? ''; // Handle imageUrl, default to empty if null

              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(content),
                  onTap: () {
                    // Navigate to PostDetailPage with post details
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(
                          title: title,
                          content: content,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );

        },
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        child: Icon(
          Icons.add_circle,
          color: Colors.grey[700],
          size: 75,
        ),
      ),
    );
  }
}
