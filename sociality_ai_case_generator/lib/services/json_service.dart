import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonService {
  // Singleton pattern for easy global access
  JsonService._privateConstructor();
  static final JsonService instance = JsonService._privateConstructor();

  final Map<String, dynamic> _cache = {};

  /// Load a JSON file from assets
  Future<Map<String, dynamic>> loadJson(String path) async {
    // Return cached version if available
    if (_cache.containsKey(path)) {
      return _cache[path];
    }

    String data = await rootBundle.loadString(path);
    Map<String, dynamic> jsonData = jsonDecode(data);
    _cache[path] = jsonData; // cache it
    return jsonData;
  }

  /// Optional: Load cards JSON specifically
  Future<List<dynamic>> loadCards(String path) async {
    Map<String, dynamic> jsonData = await loadJson(path);
    return jsonData['cards'] ?? [];
  }
}