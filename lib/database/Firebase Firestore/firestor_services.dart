import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/Authentication/auth.dart';
import 'package:facebook_app/models/posts.dart';
import 'package:facebook_app/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServices {
  FireStoreServices._();
  CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  CollectionReference postCollectionReference =
      FirebaseFirestore.instance.collection('posts');
  static final instance = FireStoreServices._();
  final List<String> listUids = [FirebaseAuth.instance.currentUser!.uid];
  final List<String> listSendedUids = [];
  final List<String> listFriendsUids = [];
  final List<String> listSentUids = [];
  int numberOfRequests = 0;
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<QuerySnapshot> getDataStreamForPuplicPosts() {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('isPublic', isEqualTo: true)
        .snapshots();
  }

  getSendedRequests(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('requests')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (!listSendedUids.contains(value.docs[i].id)) {
          listSendedUids.add(value.docs[i].id);
        }
      }
      print('Size : ${listSendedUids.length}');
      return listSendedUids.contains(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  getSentRequests(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (!listSentUids.contains(value.docs[i].id)) {
          listSentUids.add(value.docs[i].id);
        }
      }
      return listSentUids.contains(uid);
    });
  }

  isFriend(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (!listFriendsUids.contains(value.docs[i].id)) {
          listFriendsUids.add(value.docs[i].id);
        }
      }
      return listFriendsUids.contains(uid);
    });
  }

  Future<int> getNumOfRequests() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .get()
        .then((value) {
      numberOfRequests = value.docs.length;
    });
    return numberOfRequests;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataAllRequests() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .get()
        .asStream();
  }

  isExistUser(String uid) async {
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return ds.exists;
  }

  getFriends() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .get()
        .asStream();
  }

  Future<QuerySnapshot> getUsersToSerach() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  Future<QuerySnapshot> getFriendsPosts() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .get()
        .then((valueUsers) {
      for (int i = 0; i < valueUsers.docs.length; i++) {
        if (!listUids.contains(valueUsers.docs[i]['uid'])) {
          listUids.add(valueUsers.docs[i]['uid']);
        }
      }
    });

    return await FirebaseFirestore.instance
        .collection('posts')
        .where('publisherUid', whereIn: listUids.isEmpty ? [''] : listUids)
        .get();
  }

  clear() {
    listUids.removeRange(0, listUids.length);
    listFriendsUids.removeRange(0, listFriendsUids.length);
    listSendedUids.removeRange(0, listSendedUids.length);
    listSentUids.removeRange(0, listSentUids.length);
    numberOfRequests = 0;
  }

  Future<dynamic> getImgaePublisher() async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      return value.docs[0]['profileImage'];
    });
  }

  Future<dynamic> getNamePublisher() async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      return value.docs[0]['name'];
    });
  }

  Future<dynamic> getUserName(String uid) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      return value.docs[0]['name'];
    });
  }

  Future<dynamic> getUserImage(String uid) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then((value) {
      return value.docs[0]['profileImage'];
    });
  }

  Future<void> updatePostData(Post posts) {
    return postCollectionReference
        .doc(posts.postId)
        .update({'content': posts.content})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
