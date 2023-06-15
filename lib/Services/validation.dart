import 'package:flutter/cupertino.dart';

import '../app_loclization.dart';

class ValidationPassAndEmail extends ChangeNotifier {
  late String _password;
  double _strength = 0;
  double get getStrength => _strength;

  String _displayText = 'Please enter a password';
  String get getText => _displayText;
  updateStrength(double strength, String text) {
    _displayText = text;
    _strength = strength;
    notifyListeners();
  }
  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  // 1: Great

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  checkPassword(String value, BuildContext context) {
    _password = value.trim();

    if (_password.isEmpty) {
      updateStrength(0, '');
      return false;
    } else if (_password.length < 6) {
      updateStrength(1 / 4, AppLocalizations.of(context)!.translate('short'));
      return false;
    } else if (_password.length < 8) {
      updateStrength(
          2 / 4, AppLocalizations.of(context)!.translate('accbutshort'));
      return true;
    } else {
      if (!letterReg.hasMatch(_password) || !numReg.hasMatch(_password)) {
        updateStrength(
            3 / 4, AppLocalizations.of(context)!.translate('strongpass'));
        return true;
      } else {
        updateStrength(1, '');
        return true;
      }
    }
  }
}
