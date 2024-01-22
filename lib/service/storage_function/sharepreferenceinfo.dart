import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // Keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userRoleKey = "USERROLEKEY";
  static String userDescriptionKey = "USERDESCRIPTIONKEY";
  static String userIdKey = "USERIDKEY";
  static String userAvatarUrlKey = "USERAVATARURLKEY";

  // Getting the data from SharedPreferences

  // User Logged In Status
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  // Save User Logged In Status
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  // User Name
  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  // Save User Name
  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  // User Email
  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  // Save User Email
  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  // User Role
  static Future<String> getUserRoleFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userRoleKey) ?? '';
  }

  // Save User Role
  static Future<bool> saveUserRoleSF(String userRole) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userRoleKey, userRole);
  }

  // User Description
  static Future<String> getUserDescriptionSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDescriptionKey) ?? '';
  }

  // Save User Description
  static Future<bool> saveUserDescriptionSF(String userDescription) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userDescriptionKey, userDescription);
  }

  // User ID
  static Future<String?> getUserIdFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userIdKey);
  }

  // Save User ID
  static Future<bool> saveUserIdSF(String uid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userIdKey, uid);
  }

  // Method to get the user's avatar URL
  static Future<String?> getUserAvatarUrl() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userAvatarUrlKey);
  }

  // Method to save the user's avatar URL
  static Future<bool> saveUserAvatarUrl(String avatarUrl) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userAvatarUrlKey, avatarUrl);
  }


}
