import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final String uid;

  EditProfilePage({required this.uid});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  TextEditingController? _nameController;
  TextEditingController? _descriptionController;


  String userName = '';
  String userDescription = '';
  File? imageFile;
  bool isLoading = true;
  String email = '';
  String gender = '';
  String uid = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  _loadUserProfile() async {
    String uid = _auth.currentUser?.uid ?? '';
    print(uid);
    try {
      var userData = await _firestore.collection('users').doc(uid).get();
      if (userData.exists) {
        setState(() {
          userName = userData.data()?['fullName'] ?? '';
          userDescription = userData.data()?['derscription'] ?? '';
          email = userData.data()?['email'] ?? '';
          isLoading = false;
          gender = userData.data()?['gender'] ?? 'male';

        });
        _nameController = TextEditingController(text: userName);
        _descriptionController = TextEditingController(text: userDescription);
      } else {
        // Handle the case where the user data does not exist
        print("User data not found");
      }
    } catch (e) {

      // Handle any errors here
      print('Error fetching user data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      // Upload image to Firebase Storage and update user profile
    }
  }

  Future<void> _updateProfile() async {
    await _firestore.collection('users').doc(uid).update({
      'name': userName,
      'description': userDescription,
      // Update imageUrl if necessary
    });
    // Show a success message or navigate
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _descriptionController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                  child: imageFile == null ? Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: _nameController,
                onChanged: (value) {
                  userName = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
                onChanged: (value) {
                  userDescription = value;
                },
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
