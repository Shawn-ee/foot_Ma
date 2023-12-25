import 'package:chatapp_firebase/pages/ImageUploadPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'dart:io';

import '../../helper/helper_function.dart';

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
  bool isLoading = true;
  String email = '';
  String gender = '';
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

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
          userDescription = userData.data()?['description'] ?? '';
          email = userData.data()?['email'] ?? '';
          isLoading = false;
          gender = userData.data()?['gender'] ?? 'male';
          uid = userData.data()?['uid'];

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

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    for (var image in _selectedImages) {
      String fileName = 'user_images/${widget.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref(fileName).putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _uploadedImageUrls.add(downloadUrl);
    }

    // Update Firestore with the image URLs
    await _firestore.collection('users').doc(widget.uid).update({
      'imageUrls': _uploadedImageUrls,
    });

    // Clear the selected images
    setState(() {
      _selectedImages = [];
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Images uploaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _updateProfile() async {
    String uid = _auth.currentUser?.uid ?? '';
    print(uid);
    print(userName);
    print(userDescription);

    try {
      // Update Firebase
      await _firestore.collection('users').doc(uid).update({
        'fullName': userName,
        'description': userDescription,
        // Update imageUrl if necessary
      });

      _uploadImages();
      // Update SharedPreferences
      await HelperFunctions.saveUserNameSF(userName);
      // Assuming you have a method to save the description in SharedPreferences
      await HelperFunctions.saveUserDescriptionSF(userDescription);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      // Handle errors, for example, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to EditProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageUploadPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [

              GestureDetector(
                onTap: _pickImages,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _selectedImages.isNotEmpty ? FileImage(_selectedImages[0]) : null,
                  child: _selectedImages.isEmpty ? Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Select Images'),
              ),
              Wrap(
                children: _selectedImages.map((image) => Image.file(image, width: 100, height: 100)).toList(),
              ),
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
