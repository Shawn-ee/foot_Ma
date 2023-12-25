import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userRoleKey = "USERROLEKEY";
  static String userDescriptionKey = "USERDESCRIPTIONKEY";
  static String userIdKey = "USERIDKEY";


  // saving the data to SF

  static Future<String> getUserDescriptionSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDescription = prefs.getString(userDescriptionKey) ?? '';
    return userDescription;
  }

  static Future<bool> saveUserDescriptionSF(String userRole) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userDescriptionKey, userRole);
  }

  static Future<String> getUserRoleFromSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userRole = prefs.getString(userRoleKey) ?? '';
    return userRole;
  }

  static Future<bool> saveUserRoleSF(String userRole) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userRoleKey, userRole);
  }

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserIdSF(String uid) async {
    print("saving User ID");
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userIdKey, uid );
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
  static Future<String?> getUserIdFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userIdKey);
  }

}
