import 'package:facebook_app/Widgets/Animation/loading.dart';
import 'package:facebook_app/Widgets/Animation/wait.dart';
import 'package:facebook_app/Widgets/Auth/register.dart';
import 'package:facebook_app/Widgets/Auth/sign_in.dart';
import 'package:facebook_app/Widgets/Home/home.dart';
import 'package:facebook_app/Widgets/User%20Information/profile_name_bio.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_services.dart';
import 'package:facebook_app/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Authentication/auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder<Users?>(
      stream: authProvider.user,
      builder: (context, AsyncSnapshot<Users?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final Users? user = snapshot.data;
          if (user == null) {
            return const SignIn();
          } else {
            return FutureBuilder(
              future: FireStoreServices.instance.isExistUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return const HomeScreen();
                  } else {
                    return const UserInfoScreen();
                  }
                } else {
                  return const WaitingToInputData();
                }
              },
            );
          }
        } else {
          return const WaitingToInputData();
        }
      },
    );
  }
}
