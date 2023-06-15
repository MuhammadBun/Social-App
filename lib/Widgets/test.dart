import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

extension ParseToString on ConnectivityResult {
  String toValue() {
    return toString().split('.').last;
  }
}

class ConnectivityStatusExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectivityStatusExampleState();
  }
}

class _ConnectivityStatusExampleState extends State<ConnectivityStatusExample> {
  static const TextStyle textStyle = const TextStyle(
    fontSize: 16,
  );

  ConnectivityResult? _connectivityResult;
  late StreamSubscription _connectivitySubscription;
  bool? _isConnectionSuccessful;

  @override
  initState() {
    super.initState();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('Current connectivity status: $result');
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      return true;
    } else if (result == ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.woolha.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      print(e);
      setState(() {
        _isConnectionSuccessful = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Woolha.com Flutter Tutorial'),
        backgroundColor: Colors.teal,
      ),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Connection status: ${_connectivityResult?.toValue()}',
              style: textStyle,
            ),
            MaterialButton(
                child: Text('Show status'),
                onPressed: () async {
                  if (await _checkConnectivityState()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Connected!'),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Check the internet!'),
                        );
                      },
                    );
                  }
                }),
            Text(
              'Is connection success: $_isConnectionSuccessful',
              style: textStyle,
            ),
            OutlinedButton(
              child: const Text('Check internet connection'),
              onPressed: () => _checkConnectivityState(),
            ),
            OutlinedButton(
              child: const Text('Try connection'),
              onPressed: () => _tryConnection(),
            ),
          ],
        ),
      ),
    );
  }
}
