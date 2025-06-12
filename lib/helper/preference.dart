import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _loginKey = "login";
  static const String _userIdKey = "userId";

  // Simpan status login dan userId
  static Future<void> saveLogin(bool login, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, login);
    await prefs.setInt(_userIdKey, userId);
  }

  // Ambil status login
  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  // Ambil userId
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Hapus login & userId saat logout
  // Changed: This method now returns Future<void> so it can be awaited.
  static Future<void> deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_userIdKey);
  }
}
