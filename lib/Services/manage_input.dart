import 'package:facebook_app/Widgets/Auth/register.dart';
import 'package:facebook_app/Widgets/Home/home.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_user.dart';
import 'package:facebook_app/models/users.dart';
import 'package:facebook_app/providers/update_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Authentication/auth.dart';
import '../Widgets/User Information/profile_name_bio.dart';
import '../routes.dart';

class ValidatorInput {
  Future<bool> isValidForSign({
    required GlobalKey<FormState> key,
    required BuildContext context,
    required AuthProvider auth,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      FocusScope.of(context).unfocus();

      bool status = await auth.signInWithEmailAndPassword(
          emailController.text, passwordController.text);

      if (!status) {
        final snackBar = SnackBar(
          content: const Text('Please Register !'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Register()),
                ModalRoute.withName(Routes.register),
              );

              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ), (route) => false);
      }

      return true;
    }

    FocusScope.of(context).unfocus();

    return false;
  }

  Future<bool> isValidForRegister({
    required GlobalKey<FormState> key,
    required BuildContext context,
    required AuthProvider auth,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      FocusScope.of(context).unfocus();

      await auth
          .registerWithEmailAndPassword(
              emailController.text, passwordController.text, context)
          .whenComplete(() {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return const UserInfoScreen();
          },
        ), (route) => false);
      });

      return true;
    }

    FocusScope.of(context).unfocus();

    return false;
  }

  Future<bool> isValidForUserInfo({
    required GlobalKey<FormState> key,
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController bioController,
    required String imageUrl,
  }) async {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      FocusScope.of(context).unfocus();
      UserFireStore().setUser(Users(
        uid: FirebaseAuth.instance.currentUser!.uid,
        bio: bioController.text,
        name: nameController.text,
        profileImage: imageUrl,
      ));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return const HomeScreen();
        },
      ), (route) => false);
      return true;
    }

    FocusScope.of(context).unfocus();

    return false;
  }
}
