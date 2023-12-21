import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';



class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image; // Variable to hold the selected image

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  //submit post
  Future<void> submitPost(String userId, String username) async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();
    String imageUrl = '';

    if (_image != null) {
      // Upload image to Firebase Storage and get URL
      String fileName = 'post/${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    // Save post to Firestore
    FirebaseFirestore.instance.collection('post').add({
      'userId': userId, // Include the user ID
      'username': username, // Include the username
      'title': title,
      'content': content,
      'imageUrl': imageUrl, // include imageUrl, it will be empty if no image
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      // Clear the fields and image
      _titleController.clear();
      _contentController.clear();
      setState(() => _image = null);
      // Optionally navigate back or show a success message
      Navigator.pop(context);
    }).catchError((error) {
      // Handle errors, e.g., show an alert dialog
      print("Error saving post: $error");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
              SizedBox(height: 10),
              _image != null
                  ? Image.file(_image!)
                  : Text("No image selected"),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    // Assuming the username is stored in the displayName field
                    String userId = currentUser.uid;
                    String username = currentUser.displayName ?? 'Anonymous';

                    // Now call submitPost with these details
                    submitPost(userId, username);
                  } else {
                    // Handle the case where there is no authenticated user
                    print("No authenticated user found");
                  }
                },
                child: Text('Submit Post'),
              ),
            ],
          ),
      ),
    );
  }
}
