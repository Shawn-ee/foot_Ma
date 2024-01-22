import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/auth_service.dart';
import '../appDrawer.dart';
import '../auth/login_page.dart';
import '../profile_section/edit_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp_firebase/service/storage_function/storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:chatapp_firebase/pages/profilepages/Feedback.dart';
import 'package:chatapp_firebase/pages/profilepages/AboutUs.dart';
import 'package:chatapp_firebase/pages/profilepages/Contactus.dart';
import 'package:chatapp_firebase/pages/profilepages/JoinUs.dart';
import 'package:chatapp_firebase/pages/profilepages/Report.dart';
import 'package:chatapp_firebase/pages/profilepages/AddressManagement.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  List<Map<String, dynamic>> features = [
    {
      'icon': Icons.message,
      'label': 'feedback',
    },
    {
      'icon': Icons.payment,
      'label': 'contact us',
    },
    {
      'icon': Icons.location_on,
      'label': 'address management',
    },
    {
      'icon': Icons.group,
      'label': 'join us',
    },
    {
      'icon': Icons.report_problem,
      'label': 'report',
    },
    {
      'icon': Icons.info_outline,
      'label': 'about us',
    },
    // Add more items if needed
  ];

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
  AuthService authService = AuthService();

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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  size: 100, // Adjust the size as needed
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
                const Divider(height: 20),

                buildBalanceCard(balance: 120.50,
                  coupons: 5,
                  collections: 8,),

                _buildFeatureGrid(),


                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                      (route) => false,
                                );
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Logout'),
                  // style: ElevatedButton.styleFrom(
                  //   primary: Colors.red, // Button color
                  //   onPrimary: Colors.white, // Text color
                  // ),
                )
              ],
            ),
          ),
        )


    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      crossAxisCount: 3, // Number of columns
      crossAxisSpacing: 16, // Horizontal space between cards
      mainAxisSpacing: 16, // Vertical space between cards
      shrinkWrap: true, // Use this to fit the grid in the available space
      physics: NeverScrollableScrollPhysics(), // To disable GridView's scrolling
      children: widget.features.map((feature) {
        return InkWell(
          onTap: () {
            switch (feature['label']) {
              case 'feedback':
              // Navigate to suggestion (feedback) page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FeedbackPage()));
                break;
              case 'contact us':
              // Navigate to contact us (customer service) page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactUsPage()));
                break;
              case 'address management':
              // Navigate to address management page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressManagementPage()));
                break;
              case 'join us':
              // Navigate to join us (recruitment) page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => JoinUsPage()));
                break;
              case 'report':
              // Navigate to report (complaint) page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReportPage()));
                break;
              case 'about us':
              // Navigate to about us page
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AboutUsPage()));
                break;
              default:
              // Handle unknown feature
                print('Feature not implemented: ${feature['label']}');
                break;
            }
          },

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                feature['icon'],
                color: Colors.green[600],
                size: 40, // Icon size
              ),
              SizedBox(height: 8), // Space between icon and text
              Text(
                feature['label'],
                style: TextStyle(
                  fontSize: 14, // Adjust font size to fit your design
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildBalanceCard({
    required double balance,
    required int coupons,
    required int collections,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // First row: Balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            // Second row: Cards for Coupons and Collections
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCardItem(
                  icon: Icons.local_offer,
                  label: 'Coupons',
                  count: coupons,
                ),
                _buildCardItem(
                  icon: Icons.collections,
                  label: 'Collect',
                  count: collections,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

}
