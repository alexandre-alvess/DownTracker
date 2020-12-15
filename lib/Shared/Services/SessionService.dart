import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService
{
  static Future<void> _saveString(String value) async
  {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_session', value);
  }

  static Future<void> saveSessionMap(Map<String, dynamic> map) async
  {
    _saveString(jsonEncode(map));
  }

  static Future<String> _getString() async
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('app_session');
  }

  static Future<Map<String, dynamic>> getSessionMap() async
  {
    try
    {
      Map<String, dynamic> map = jsonDecode(await _getString());
      return map;
    }
    catch(_)
    {
      return null;
    }
  }

  static Future<bool> logoutSession() async
  {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('app_session');
  }
}