import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appDrawer.dart';
import '../profile_section/edit_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp_firebase/service/storage_function/storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
  // UserProfileService? userProfileService;

  bool isLoading = true;
  String userName = '';
  String userDescription = '';
  String email = '';
  String gender = '';
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {

    String filename =  '${widget.userId}.png';
    String localpath = await _fileStorageService.getlocalAvatarpath(widget.userId);
    try{
      if (localpath != "") {
        // Load from local file
        setState(() {
          avatarUrl = localpath;
        });
      }
      else {
        String? firebaseImageUrl = await _fileStorageService.loadAvatarurl(widget.userId);
        if (firebaseImageUrl == null) {
          print('No avatar URL available');
          return;
        }
        // Download from Firebase and save locally
        File downloadedFile = await _fileStorageService.downloadAndSaveImage(firebaseImageUrl, filename);
        setState(() {
          avatarUrl = downloadedFile.path;
        });
      }

    }
    catch(e){
      print("User data not found");
      return null;
    }

  }
  Future<void> loadUserProfile() async {
    var data = await _fileStorageService?.loadUserProfile();
    if (data != null) {
      setState(() {
        print('Setting userName: ${data['fullName']}');
        userName = data['fullName'] ?? '';

        print('Setting userDescription: ${data['description']}');
        userDescription = data['description'] ?? '';

        print('Setting email: ${data['email']}');
        email = data['email'] ?? '';

        print('Setting gender: ${data['gender']}');
        gender = data['gender'] ?? 'male';

        isLoading = false;
        print('Setting isLoading: false');
      });
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
                radius: 100, // Adjust the radius as needed
                backgroundImage: FileImage(File(avatarUrl!)),
                backgroundColor: Colors.transparent,
              )
                  : Icon(
                      Icons.account_circle,
                      size: 200, // Adjust the size as needed
                      color: Colors.grey[700], // You can adjust the color as needed
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
