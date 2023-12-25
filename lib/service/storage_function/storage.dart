import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';


class FileStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get the path to the application's documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Create a reference to the file, in the documents directory
  Future<File> localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  // Write data to the file
  Future<File> writeToFile(String fileName, String data) async {
    final file = await localFile(fileName);
    return file.writeAsString(data);
  }

  // Read data from the file
  Future<String> readFromFile(String fileName) async {
    try {
      final file = await localFile(fileName);
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return an empty string or handle the error appropriately
      print('Error reading file: $e');
      return '';
    }
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

  // Load a user's avatar from Firebase Storage
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
