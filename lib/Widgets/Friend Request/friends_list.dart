import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/Services/connection.dart';
import 'package:facebook_app/Widgets/Animation/loading.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_friend.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_services.dart';

import 'package:facebook_app/models/request.dart';
import 'package:facebook_app/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../app_loclization.dart';
import '../Home/search.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream =
      FriendFireStore().getFriends();
  getStream() {
    setState(() {
      stream = FriendFireStore().getFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(AppLocalizations.of(context)!.translate('friendlist')),
        ),
        body: FutureBuilder(
          future: AppConnection().checkConnectivityState(),
          builder: (context, snapshot) {
            return snapshot.data == true
                ? StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.size == 0) {
                          return Center(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minWidth: 120,
                              onPressed: () async {
                                if (await AppConnection()
                                    .checkConnectivityState()) {
                                  showSearch(
                                      context: context,
                                      delegate: UserSearch(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .translate('search')));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .translate('checkinternet')),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 100,
                                                        height: 70,
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                },
                                              );
                                              await AppSettings
                                                  .openWIFISettings(
                                                      asAnotherTask: true);
                                              Navigator.of(context).pop();

                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate('presstocheck')),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                width: 130,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate('searchfriends'),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(Icons.search, color: Colors.white)
                                    ]),
                              ),
                              color: Colors.blue,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 100,
                                decoration: const BoxDecoration(
                                    border:
                                        Border(bottom: BorderSide(width: 0.3))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data!
                                              .docs[index]['profileImage']),

                                          radius: 35, // Image radius
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['name'],
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        MaterialButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                    content: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ));
                                              },
                                            );
                                            await FriendFireStore()
                                                .deleteFriend(
                                                    snapshot.data!.docs[index]
                                                        ['uid'],
                                                    Users(
                                                        uid: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid))
                                                .whenComplete(() async {
                                              await FriendFireStore()
                                                  .deleteFriend(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      Users(
                                                          uid: snapshot.data!
                                                                  .docs[index]
                                                              ['uid']))
                                                  .whenComplete(() {
                                                Navigator.of(context).pop();
                                              });
                                            });

                                            getStream();
                                          },
                                          color: Colors.red,
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('delete')),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return ListView.builder(
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            return const LoadingPosts();
                          },
                        );
                        ;
                      }
                    },
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_find_outlined,
                          size: 200,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Text(AppLocalizations.of(context)!
                            .translate('checkinternet'))
                      ],
                    ),
                  );
          },
        ));
  }
}
