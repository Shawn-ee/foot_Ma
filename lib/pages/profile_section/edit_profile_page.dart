import 'package:chatapp_firebase/pages/profile_section/ImageUploadPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'dart:io';

import '../../service/storage_function/sharepreferenceinfo.dart';
import '../../service/storage_function/storage.dart';

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
  late FileStorageService _fileStorageService;


  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    var data = await _fileStorageService?.loadUserProfile();
    if (data != null) {
      setState(() {
        userName = data['fullName'] ?? '';
        userDescription = data['description'] ?? '';
        email = data['email'] ?? '';
        gender = data['gender'] ?? 'male';
        isLoading = false;
      });
    }
    _nameController = TextEditingController(text: userName);
    _descriptionController = TextEditingController(text: userDescription);
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
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
                onPressed: () async {
                  // Call the updateProfile method inside an async function
                  await _fileStorageService.updateProfile(userName, userDescription);
                  // You can add additional code here to handle after the profile is updated
                },
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
