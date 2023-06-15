import 'dart:io';

import 'package:facebook_app/database/firebase_path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as error_upload;

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> uploadFile(String path, String fileName) async {
    File file = File(path);
    try {
      await storage.ref(PathServices.profile(fileName)).putFile(file);
    } on error_upload.FirebaseException catch (e) {
      print(e);
    }
  }

  Future listFiles() async {
    final files = await storage.ref('profiles').listAll();
    files.items.forEach((element) {
      print('element.name:::::::::::::::::::');
      print(element.name);
    });
    return files;
  }

  Future<String> downloadURL(String fileName) async {
    String downloadURL =
        await storage.ref(PathServices.profile(fileName)).getDownloadURL();
    return downloadURL;
  }
}
