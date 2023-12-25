import 'package:firebase_storage/firebase_storage.dart';

class UserProfileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to load a user's avatar from Firebase Storage
  Future<String?> loadAvatar(String userId) async {
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
}
