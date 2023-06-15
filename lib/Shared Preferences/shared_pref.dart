import 'package:shared_preferences/shared_preferences.dart';

class SharedAppPreferences {
  static const themeStatus = "THEMESTATUS";
  static const String languagecode = "language_code";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
          themeStatus,
        ) ??
        false;
  }

  setLanguage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(languagecode, value);
  }

  Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
          languagecode,
        ) ??
        'en';
  }
}
