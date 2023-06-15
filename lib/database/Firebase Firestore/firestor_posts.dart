import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/models/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_path.dart';
import 'firestor_friend.dart';
import 'firestor_services.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

enum PostStatus { postingStatus, cancelStatus, noPostingStatus, getPostsStatus }

class PostFireStore {
  final _firestoreService = FireStoreServices.instance;
  PostStatus _status = PostStatus.noPostingStatus;
  PostStatus get postStatus => _status;

  Future<void> setPost(Post post) async {
    return await _firestoreService.setData(
      path: PathServices.post(post.postId),
      data: post.toMap(),
    );
  }

  getFriendsPosts() {
    return _firestoreService.getFriendsPosts();
  }

  Future<void> deletePost(Post post) async =>
      await _firestoreService.deleteData(
        path: PathServices.post(post.postId),
      );
  Stream<QuerySnapshot> getPosts() {
    return _firestoreService.getDataStreamForPuplicPosts();
  }

  Future<dynamic> getImgaePublisher() async {
    return _firestoreService.getImgaePublisher();
  }

  Future<dynamic> getNamePublisher() async {
    return _firestoreService.getNamePublisher();
  }
}
