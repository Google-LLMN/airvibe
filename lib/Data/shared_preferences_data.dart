/// This file can store permanent data that you want to save

import 'package:shared_preferences/shared_preferences.dart';


// Experimental. May cause memory leak. (No its not.)
class SavedLocation {
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

class SavedNewsSource {
  static Future<int?> getSelectedNewsSource() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedValue');
  }
  static Future<void> saveSelectedNewsSource(int newsSources) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedValue', newsSources);
  }
}