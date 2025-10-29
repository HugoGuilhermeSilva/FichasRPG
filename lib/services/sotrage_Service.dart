import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
  Future<String?> loadString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
  Future<void> saveStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
  Future<List<String>?> loadStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
  Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }
  Future<Map<String, dynamic>?> loadMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
}