import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/models/posts.dart';
import 'package:facebook_app/models/request.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_path.dart';
import 'firestor_services.dart';

class RequestFireStore {
  final _firestoreService = FireStoreServices.instance;

  Future<void> newRequest(RequestFriend requestFriend) async =>
      await _firestoreService.setData(
        path: PathServices.request(
            requestFriend.requestId, requestFriend.uidRecevier),
        data: requestFriend.toMap(),
      );
  Future<void> deleteRequest(String requestFriend) async =>
      await _firestoreService.deleteData(
        path: PathServices.request(
            requestFriend, FirebaseAuth.instance.currentUser!.uid),
      );
  getDataAllRequests() {
    return _firestoreService.getDataAllRequests();
  }

  getSendedRequests(String uid) {
    return _firestoreService.getSendedRequests(uid);
  }

  getSentRequests(String uid) {
    return _firestoreService.getSentRequests(uid);
  }

  getNumOfRequests() {
    return _firestoreService.getNumOfRequests();
  }
}
