import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

enum ConnectStatus {
  isConnected,
  notConnectd,
  connecting,
}

class AppConnection {
  late ConnectivityResult result;
  ConnectStatus _status = ConnectStatus.isConnected;
  ConnectStatus get status => _status;
  checkConnectivityState() async {
    _status = ConnectStatus.connecting;
    result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      _status = ConnectStatus.isConnected;
      return true;
    } else if (result == ConnectivityResult.mobile) {
      _status = ConnectStatus.isConnected;

      return true;
    } else {
      _status = ConnectStatus.notConnectd;
      return false;
    }
  }
}
