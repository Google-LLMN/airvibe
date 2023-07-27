import 'package:shared_preferences/shared_preferences.dart';

// Experimental. May cause memory leak.
class SharedPreferencesUtils {
  static Future<void> saveSelectedAUState(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCity', city);
  }

  static Future<String?> getSelectedAUState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedCity');
  }

  static Future<void> saveSelectedUrban(String urban) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedUrban', urban);
  }

  static Future<String?> getSelectedUrban() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedUrban');
  }
}
