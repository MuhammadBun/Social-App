import 'package:flutter/material.dart';

import '../Shared Preferences/shared_pref.dart';

class DarkThemeProvider with ChangeNotifier {
  SharedAppPreferences darkThemePreferences = SharedAppPreferences();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}
