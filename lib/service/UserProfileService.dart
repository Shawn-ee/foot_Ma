import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../helper/helper_function.dart';

class UserProfileService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserProfileService(this._auth, this._firestore);

  Future<Map<String, dynamic>?> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = _auth.currentUser?.uid ?? '';

    try {
      // Check if user data is in local cache
      if (prefs.containsKey('user_$uid')) {
        final userData = prefs.getString('user_$uid');

        if (userData != null && userData.isNotEmpty) {
          return json.decode(userData) as Map<String, dynamic>;
        }
      }

      // Fetch from Firestore if not in local cache
      var userData = await _firestore.collection('users').doc(uid).get();
      if (userData.exists) {
        // Save data to local cache
        prefs.setString('user_$uid', json.encode(userData.data()));
        return userData.data();
      } else {
        // Handle the case where the user data does not exist
        print("User data not found");
        return null;
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateProfile(String userName, String userDescription) async {
    String uid = _auth.currentUser?.uid ?? '';
    try {
      // Update Firebase
      await _firestore.collection('users').doc(uid).update({
        'fullName': userName,
        'description': userDescription,
        // Update imageUrl if necessary
      });
      await HelperFunctions.saveUserNameSF(userName);
      // Assuming you have a method to save the description in SharedPreferences
      await HelperFunctions.saveUserDescriptionSF(userDescription);

      // Update SharedPreferences
      // Replace with your methods to save data in SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('userName', userName);
      // prefs.setString('userDescription', userDescription);

      // Return successfully
      return;
    } catch (e) {
      // Rethrow the exception to handle it in the calling widget
      throw Exception('Failed to update profile: $e');
    }
  }

}
