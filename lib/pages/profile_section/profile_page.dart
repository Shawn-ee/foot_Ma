import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/auth_service.dart';
import '../appDrawer.dart';
import 'edit_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp_firebase/service/storage_function/storage.dart';

import 'dart:io';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FileStorageService _fileStorageService = FileStorageService();



  bool isLoading = true;
  String userName = '';
  String userDescription = '';
  String email = '';
  String gender = '';
  String? avatarUrl;

  @override
  void initState() {
    super.initState();

    _fileStorageService.loadAvatar(widget.userId);
    _loadUserProfile();
  }

  _loadUserProfile() async {
    String uid = _auth.currentUser?.uid ?? '';
    try {
      var userData = await _firestore.collection('users').doc(uid).get();
      if (userData.exists) {
        setState(() {
          userName = userData.data()?['fullName'] ?? '';
          userDescription = userData.data()?['description'] ?? '';
          email = userData.data()?['email'] ?? '';
          isLoading = false;
          gender = userData.data()?['gender'] ?? 'male';
        });
      } else {
        // Handle the case where the user data does not exist
        print("User data not found");
      }
    } catch (e) {

      // Handle any errors here
      print('Error fetching user data: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to EditProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(uid: widget.userId)),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
          child: Column(
            children: <Widget>[
              avatarUrl != null && avatarUrl!.isNotEmpty
                  ? CircleAvatar(
                radius: 100, // Adjust the size to fit your design
                backgroundImage: NetworkImage(avatarUrl!),
                backgroundColor: Colors.transparent,
              )
                  : Icon(
                Icons.account_circle,
                size: 200,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Assuming you have a variable `gender` which can be 'male', 'female', or other
                  Icon(
                    gender == 'male' ? Icons.male : Icons.female,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    gender.toUpperCase(), // Convert gender to uppercase for display
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Name", style: TextStyle(fontSize: 17)),
                  Text(userName, style: const TextStyle(fontSize: 17)),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email", style: TextStyle(fontSize: 17)),
                  Text(email, style: const TextStyle(fontSize: 17)),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Description", style: TextStyle(fontSize: 17)),
                  Flexible(
                    child: Text(
                      userDescription,
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )


    );
  }
}
