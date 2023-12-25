import 'package:shared_preferences/shared_preferences.dart';

void viewSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get all keys
  Set<String> keys = prefs.getKeys();

  // Iterate over the keys
  for (String key in keys) {
    var value = prefs.get(key);
    print('$key: $value');
  }
}