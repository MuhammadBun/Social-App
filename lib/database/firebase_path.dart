import 'package:facebook_app/models/friend_ship.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/users.dart';

class PathServices {
  static String profile(String fileName) => 'profiles/$fileName';
  static String user(String uid) => 'users/$uid';
  static String post(String postid) => 'posts/$postid';
  static String request(String requestId, String uid) =>
      'users/$uid/requests/$requestId';
  static String friend(String friendId, Users user) =>
      'users/$friendId/friends/${user.uid}';
}
