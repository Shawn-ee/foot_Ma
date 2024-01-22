import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp_firebase/classes/comment.dart';
import 'sharepreferenceinfo.dart';


class FileStorageService {
  static final FileStorageService _instance = FileStorageService._internal();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  factory FileStorageService() {
    return _instance;
  }

  FileStorageService._internal();




  Future<Map<String, dynamic>?> loadUserProfile() async {
    var data = getUserDataFromCache();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = _auth.currentUser?.uid ?? '';

    try {
      // Check if user data is in local cache
      if (prefs.containsKey('user_$uid')) {
        print("Data retrieved from cache: $data");
        return data;
      }
      else{
        var userData = await _firestore.collection('users').doc(uid).get();
        if (userData.exists) {
          var userDataMap = userData.data() as Map<String, dynamic>;
          prefs.setString('user_$uid', json.encode(userDataMap));
          print("Data retrieved from Firestore: $userDataMap");
          return userDataMap;
        } else {
          print("User data not found in Firestore");
          return null;
        }
      }
      // Fetch from Firestore if not in local cache

    } catch (e) {
      // Handle any errors here
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future <void> updateProfile(String userName, String userDescription) async {
    String uid = _auth.currentUser?.uid ?? '';
    try {
      // Update Firebase
      await _firestore.collection('users').doc(uid).update({
        'fullName': userName,
        'description': userDescription,
        // Update imageUrl if necessary
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('sfname');
      print(userName);
      prefs.setString('fullName', userName);
      prefs.setString('description', userDescription);

      // Return successfully

    } catch (e) {
      // Rethrow the exception to handle it in the calling widget
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<Map<String, String>> getUserDataFromCache() async {
    // Fetch user data
    String roleValue = await HelperFunctions.getUserRoleFromSF() ?? '';
    String userEmail = await HelperFunctions.getUserEmailFromSF() ?? '';
    String userNameValue = await HelperFunctions.getUserNameFromSF() ?? '';
    String userIDValue = await HelperFunctions.getUserIdFromSF() ?? '';
    return {
      'uid': userIDValue,
      'userRole': roleValue,
      'email': userEmail,
      'userName': userNameValue,
    };
  }

  // Upload an image to Firebase and return the download URL
  Future<String> uploadImage(File imageFile, String filePath) async {
    try {
      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }


  Future<File?> getLocalAvatarFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    return file.existsSync() ? file : null;
  }

  Future<String> getlocalAvatarpath(uid) async {
    String url;
    String filename =  '$uid.png';
    File? localFile = await getLocalAvatarFile(filename);
    print('localfile.path');
    if (localFile != null) {
      // Load from local file
      url = localFile.path;
      print(localFile.path);
      return url;
    }
    return "";
  }

  //download image and save to local
  Future<File> downloadAndSaveImage(String url, String filename) async {

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    return file.writeAsBytes(response.bodyBytes);
  }

  // Load a user's avatar from Firebase Storage
  Future<String?> loadAvatarurl(String userId) async {
    try {
      String path = 'user/$userId/profile_pictures/$userId.jpg';
      String url = await _storage.ref(path).getDownloadURL();
      return url;
    } catch (e) {
      // If fetching fails, return null or handle the error as needed
      print('Failed to load avatar: $e');
      return null;
    }
  }

  Future<bool> uploadAvatar(File imageFile) async {
    try {
      String uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        print('User ID is empty');
        return false;
      }

      // Define the file path in Firebase Storage
      String filePath = 'user/$uid/profile_pictures/$uid.jpg';

      // Upload the image
      String downloadUrl = await uploadImage(imageFile, filePath);
      if (downloadUrl.isEmpty) {
        print('Failed to get download URL');
        return false;
      }

      // Update the user's profile in Firestore
      await _firestore.collection('users').doc(uid).update({
        'avatarUrl': downloadUrl,
      });

      // Update the avatar URL in Shared Preferences
      await HelperFunctions.saveUserAvatarUrl(downloadUrl);

      return true;
    } catch (e) {
      print('Error uploading avatar: $e');
      return false;
    }
  }

  Future<String> loadProfileUrl(String userId) async {
    try {
      String path = 'masseurs/$userId/profile.png';
      String url = await _storage.ref(path).getDownloadURL();
      print('downloarurl');
      print(url);
      return url;
    } catch (e) {
      // If fetching fails, return null or handle the error as needed
      print('Failed to load picture: $e');
      return "";
    }
  }

  Future<List<String>> loadAllUrls(String userId) async {
    List<String> urls = [];
    try {
      String folderPath = 'masseurs/$userId';
      // Get the reference to the folder
      ListResult result = await _storage.ref(folderPath).listAll();

      // Fetch URLs for all items
      for (var ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }

      // Sort URLs to ensure the profile picture is first
      String profilePath = '$folderPath/profile.png';
      int profileIndex = urls.indexWhere((url) => url.contains(profilePath));
      if (profileIndex != -1) {
        String profileUrl = urls.removeAt(profileIndex);
        urls.insert(0, profileUrl); // Insert the profile URL at the beginning
      }

    } catch (e) {
      print('Failed to load pictures: $e');
    }
    return urls;
  }

  Future<List<Comment>> fetchComments(String masseurId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection('masseurs')
        .doc(masseurId)
        .collection('comments')
        .get();

    List<Comment> comments = snapshot.docs.map((doc) {
      return Comment.fromFirestore(doc);
    }).toList();

    return comments;
  }




  static String fetchPictureUrl(
      String uniqueId,
      String token,
      {
        String basePath = 'https://firebasestorage.googleapis.com/v0/b/massageking-d3058.appspot.com/o/',
        String fileName = 'profile.png', // Default file name
      }
      ) {
    // Encoding the file path
    String filePath = 'masseurs/$uniqueId/$fileName';
    String encodedFilePath = filePath.split('/').map((part) => Uri.encodeComponent(part)).join('%2F');

    // Constructing the final image URL
    String imageUrl = '$basePath$encodedFilePath?alt=media&token=$token';

    return imageUrl;
  }


}



