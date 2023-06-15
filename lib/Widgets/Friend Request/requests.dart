import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/models/friend_ship.dart';

import 'package:facebook_app/models/request.dart';
import 'package:facebook_app/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../Services/connection.dart';
import '../../app_loclization.dart';
import '../../database/Firebase Firestore/firestor_friend.dart';
import '../../database/Firebase Firestore/firestor_services.dart';
import '../../database/Firebase Firestore/firestor_user.dart';
import '../../database/Firebase Firestore/firestore_request.dart';
import '../../providers/theme_provider.dart';
import '../Animation/loading.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream =
      RequestFireStore().getDataAllRequests();
  getStream() {
    setState(() {
      stream = RequestFireStore().getDataAllRequests();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            AppLocalizations.of(context)!.translate('requests'),
            style: TextStyle(
                color: themeChange.darkTheme ? Colors.white : Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: AppConnection().checkConnectivityState(),
          builder: (context, snapshot) {
            return snapshot.data == true
                ? StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: 100,
                              decoration: const BoxDecoration(
                                  border: const Border(
                                      bottom: BorderSide(width: 0.3))),
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
                                            .docs[index]['imageUrlSender']),

                                        radius: 35, // Image radius
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]
                                            ['nameSender'],
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

                                          Users user1 = Users(
                                              uid: snapshot.data!.docs[index]
                                                  ['uidSender'],
                                              name: await UserFireStore()
                                                  .getUserName(
                                                      snapshot.data!.docs[index]
                                                          ['uidSender']),
                                              profileImage:
                                                  await UserFireStore()
                                                      .getUserImage(snapshot
                                                              .data!.docs[index]
                                                          ['uidSender']));

                                          Users user2 = Users(
                                              uid: snapshot.data!.docs[index]
                                                  ['uidRecevier'],
                                              name: await UserFireStore()
                                                  .getUserName(
                                                      snapshot.data!.docs[index]
                                                          ['uidRecevier']),
                                              profileImage:
                                                  await UserFireStore()
                                                      .getUserImage(snapshot
                                                              .data!.docs[index]
                                                          ['uidRecevier']));

                                          await FriendFireStore().setFriend(
                                              snapshot.data!.docs[index]
                                                  ['uidRecevier'],
                                              user1);
                                          await FriendFireStore().setFriend(
                                              snapshot.data!.docs[index]
                                                  ['uidSender'],
                                              user2);

                                          await RequestFireStore()
                                              .deleteRequest(snapshot.data!
                                                  .docs[index]['requestId'])
                                              .whenComplete(() {
                                            Navigator.of(context).pop();
                                          });
                                          getStream();
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Color.fromARGB(255, 20, 19, 19)
                                            .withOpacity(0.2),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .translate('accepte')),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            await RequestFireStore()
                                                .deleteRequest(snapshot.data!
                                                    .docs[index]['requestId']);
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            size: 30,
                                            color: Colors.red,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            return const LoadingPosts();
                          },
                        );
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
