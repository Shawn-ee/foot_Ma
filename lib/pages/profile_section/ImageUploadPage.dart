import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../../service/storage_function/storage.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';



  Future<void> _pickImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  Future<void> _uploadImages() async {
    FileStorageService fileStorageService = FileStorageService();

    for (var image in _selectedImages) {
      String fileName = 'user/$uid/profile_pictures/$uid.jpg';

      // Use the file storage service to upload the image
      String downloadUrl = await fileStorageService.uploadImage(image, fileName);
      if (downloadUrl.isNotEmpty) {
        _uploadedImageUrls.add(downloadUrl);
      }
    }

    // Update Firestore with the image URLs
    await _firestore.collection('users').doc(uid).update({
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: _uploadImages,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.add_a_photo),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          _selectedImages.length,
              (index) {
            return Image.file(_selectedImages[index], fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}
