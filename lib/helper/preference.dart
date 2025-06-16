import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _loginKey = "login";
  static const String _userIdKey = "userId";

  // u/ menyimpan status login dan userId
  static Future<void> saveLogin(bool login, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, login);
    await prefs.setInt(_userIdKey, userId);
  }

  // u/ mengambil status login
  static Future<bool> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  //u/ mengambil userId
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  static Future<void> deleteLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_userIdKey);
  }
}

//.
