import 'package:flutter/cupertino.dart';

class SearchItemProvider extends ChangeNotifier {
  final String _name = '';
  String get getName => _name;
  updateName(String uid) {
    uid = _name;
    notifyListeners();
  }
}
