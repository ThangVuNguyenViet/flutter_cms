import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage adapters for CMS Studio models using SharedPreferences
/// This provides a simple key-value storage for schema and content data
class StudioStorageAdapters {
  static const String _schemasKey = 'cms_studio_schemas';
  static const String _contentKey = 'cms_studio_content';
  static const String _sessionKey = 'cms_studio_session';
  static const String _workspaceKey = 'cms_studio_workspace';

  /// Get SharedPreferences instance
  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Save schema data as JSON
  static Future<void> saveSchemas(Map<String, dynamic> schemas) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(schemas);
    await prefs.setString(_schemasKey, jsonString);
  }

  /// Load schema data from JSON
  static Future<Map<String, dynamic>> loadSchemas() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_schemasKey);
    if (jsonString == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      // Return empty map if JSON is invalid
      return {};
    }
  }

  /// Save content data as JSON
  static Future<void> saveContent(Map<String, dynamic> content) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(content);
    await prefs.setString(_contentKey, jsonString);
  }

  /// Load content data from JSON
  static Future<Map<String, dynamic>> loadContent() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_contentKey);
    if (jsonString == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      // Return empty map if JSON is invalid
      return {};
    }
  }

  /// Save session data as JSON
  static Future<void> saveSession(Map<String, dynamic> session) async {
    final prefs = await _prefs;
    final jsonString = jsonEncode(session);
    await prefs.setString(_sessionKey, jsonString);
  }

  /// Load session data from JSON
  static Future<Map<String, dynamic>> loadSession() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_sessionKey);
    if (jsonString == null) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    } catch (e) {
      // Return empty map if JSON is invalid
      return {};
    }
  }

  /// Save workspace preferences
  static Future<void> saveWorkspacePreference(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString('${_workspaceKey}_$key', value);
  }

  /// Load workspace preference
  static Future<String?> loadWorkspacePreference(String key) async {
    final prefs = await _prefs;
    return prefs.getString('${_workspaceKey}_$key');
  }

  /// Clear all studio data (for testing or reset)
  static Future<void> clearAllData() async {
    final prefs = await _prefs;
    await prefs.remove(_schemasKey);
    await prefs.remove(_contentKey);
    await prefs.remove(_sessionKey);

    // Remove all workspace preferences
    final keys = prefs.getKeys().where((key) => key.startsWith(_workspaceKey));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Get storage statistics for debugging
  static Future<Map<String, int>> getStorageStats() async {
    final prefs = await _prefs;
    return {
      'schemas_size': (prefs.getString(_schemasKey) ?? '').length,
      'content_size': (prefs.getString(_contentKey) ?? '').length,
      'session_size': (prefs.getString(_sessionKey) ?? '').length,
      'total_keys': prefs.getKeys().length,
    };
  }
}