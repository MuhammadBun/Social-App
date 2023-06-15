import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/models/friend_ship.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/users.dart';
import '../firebase_path.dart';
import 'firestor_posts.dart';
import 'firestor_services.dart';

class FriendFireStore {
  final List<String> listUids = [];

  final _firestoreService = FireStoreServices.instance;

  Future<void> setFriend(String friendId, Users user) async =>
      await _firestoreService.setData(
        path: PathServices.friend(friendId, user),
        data: user.toMap(),
      );
  Future<void> deleteFriend(String friendId, Users user) async =>
      await _firestoreService.deleteData(
        path: PathServices.friend(friendId, user),
      );

  isFriend(String uid) {
    return _firestoreService.isFriend(uid);
  }

  getFriends() {
    return _firestoreService.getFriends();
  }
}
