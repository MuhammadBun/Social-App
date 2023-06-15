import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/users.dart';
import '../firebase_path.dart';
import 'firestor_services.dart';

class UserFireStore {
  final _firestoreService = FireStoreServices.instance;
  CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  Future<void> setUser(Users user) async => await _firestoreService.setData(
        path: PathServices.user(user.uid),
        data: user.toMap(),
      );
  Future<void> deleteUser(Users user) async =>
      await _firestoreService.deleteData(
        path: PathServices.user(user.uid),
      );
  getUsersToSerach() {
    return _firestoreService.getUsersToSerach();
  }

  Future<dynamic> getUserName(String uid) async {
    return _firestoreService.getUserName(uid);
  }

  Future<dynamic> getUserImage(String uid) async {
    return _firestoreService.getUserImage(uid);
  }

  isUserExist(String uid) {
    return _firestoreService.isExistUser(uid);
  }
}
