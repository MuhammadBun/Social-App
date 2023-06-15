import 'package:flutter/cupertino.dart';

import '../Shared Preferences/shared_pref.dart';

class LanguageProvider extends ChangeNotifier {
  late SharedAppPreferences _sharedPrefHelper;
  Locale _appLocale = const Locale("en");

  LanguageProvider() {
    _sharedPrefHelper = SharedAppPreferences();
  }

  Locale get appLocale {
    _sharedPrefHelper.getLanguage().then((value) {
      _appLocale = Locale(value);
    });
    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    if (languageCode == "ar") {
      _appLocale = const Locale("ar");
    } else {
      _appLocale = const Locale("en");
    }

    _sharedPrefHelper.setLanguage(languageCode);
    notifyListeners();
  }
}
