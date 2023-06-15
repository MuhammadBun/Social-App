import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';

import '../database/Firebase Firestore/firestor_services.dart';

class UpdateUi extends ChangeNotifier {
  int _tabCount = 0;
  int _size = 0;
  int _value = 0;
  int _index = 0;
  List<int> _listOfInedx = [];
  bool _send = false;
  bool _active = false;
  bool _ob = true;
  Alignment _locale = Alignment.bottomLeft;

  int get getTabCount => _tabCount;

  List<int> get getListOfIndex => _listOfInedx;
  int get getTabSize => _size;
  int get getValue => _value;
  bool get getSend => _send;
  bool get getOb => _ob;
  bool get getActive => _active;
  Alignment get getLocal => _locale;
  int length = 0;
  updateTapColorIcon(int tapCount) {
    _tabCount = tapCount;
    notifyListeners();
  }

  updateAddIndex(int index) {
    _listOfInedx.add(index);

    notifyListeners();
  }

  updateRemoveIndex(List<int> list) {
    _listOfInedx.removeRange(0, list.length);
    notifyListeners();
  }

  updateValue(int value) {
    _value = value;
    notifyListeners();
  }

  updateTapSizeIcon(int size) {
    _size = size;
    notifyListeners();
  }

  updatePostButton(bool active) {
    _active = active;
    notifyListeners();
  }

  updateOb(bool ob) {
    _ob = ob;
    notifyListeners();
  }

  updateSendButton(bool send) {
    _send = send;
    notifyListeners();
  }
}
