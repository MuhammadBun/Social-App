import 'package:facebook_app/Widgets/Auth/sign_in.dart';
import 'package:facebook_app/Widgets/Auth/wrapper.dart';
import 'package:facebook_app/Widgets/Friend%20Request/friends_list.dart';
import 'package:facebook_app/Widgets/Friend%20Request/requests.dart';
import 'package:facebook_app/Widgets/Home/home.dart';
import 'package:facebook_app/Widgets/Home/input_post.dart';
import 'package:facebook_app/Widgets/Posts/list_post_friends.dart';
import 'package:flutter/cupertino.dart';
import 'Widgets/Auth/register.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object
  static const String wrapper = '/';

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String newPost = '/newPost';
  static const String requests = '/requests';
  static const String friends = '/friends';
  static const String postFriends = '/postFriends';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => const SignIn(),
    register: (BuildContext context) => const Register(),
    wrapper: (BuildContext context) => const Wrapper(),
    newPost: (BuildContext context) => const AddPostScreen(),
    requests: (BuildContext context) => const RequestScreen(),
    friends: (BuildContext context) => const FriendsScreen(),
    postFriends: (BuildContext context) => const ListPostFriends(),
    home: (BuildContext context) => const HomeScreen(),
  };
}
