import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app/Widgets/Animation/loading.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_user.dart';
import 'package:facebook_app/providers/update_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_loclization.dart';
import '../../database/Firebase Firestore/firestor_services.dart';
import '../../database/Firebase Firestore/firestore_request.dart';
import '../../models/request.dart';
import '../../providers/theme_provider.dart';
import '../../routes.dart';

class UserSearch extends SearchDelegate {
  late final String? hintText;
  UserSearch({this.hintText});

  @override
  String? get searchFieldLabel => hintText;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return returnBulder(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return returnBulder(context);
  }

  returnBulder(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final updateUi = Provider.of<UpdateUi>(context);
    String sender = '';
    late bool isFriend = true;
    late bool isRequested;
    late bool isSent;
    bool isSelected;
    return FutureBuilder<QuerySnapshot>(
      future: UserFireStore().getUsersToSerach(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              isSelected = updateUi.getListOfIndex.contains(index);

              if (snapshot.data!.docs[index]['name']
                  .toString()
                  .toLowerCase()
                  .startsWith(query.toLowerCase())) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.3))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey,

                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['profileImage'],
                            ),

                            radius: 35, // Image radius
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            snapshot.data!.docs[index]['name'],
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {},
                              icon: Icon(
                                Icons.remove_red_eye_sharp,
                                size: 30,
                                color: Colors.grey,
                              )),
                          MaterialButton(
                            onPressed: () async {
                              isRequested = await FireStoreServices.instance
                                  .getSendedRequests(
                                      snapshot.data!.docs[index]['uid']);
                              isFriend = await FireStoreServices.instance
                                  .isFriend(snapshot.data!.docs[index]['uid']);

                              isSent = await FireStoreServices.instance
                                  .getSentRequests(
                                      snapshot.data!.docs[index]['uid']);

                              if (isSent) {
                                isSelected = false;

                                final snackBar = SnackBar(
                                  backgroundColor: themeChange.darkTheme
                                      ? Color.fromARGB(255, 16, 16, 16)
                                      : Colors.white,
                                  content: Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' ${AppLocalizations.of(context)!.translate('isalreadyssentrequest')} ${snapshot.data!.docs[index]['name']} ',
                                          style: TextStyle(
                                              color: !themeChange.darkTheme
                                                  ? Color.fromARGB(
                                                      255, 16, 16, 16)
                                                  : Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.redAccent
                                                            .withOpacity(0.3))),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed(Routes.requests);
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('gotorequests'),
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (isFriend) {
                                final snackBar = SnackBar(
                                  backgroundColor: themeChange.darkTheme
                                      ? Color.fromARGB(255, 16, 16, 16)
                                      : Colors.white,
                                  content: Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${snapshot.data!.docs[index]['name']} ${AppLocalizations.of(context)!.translate('isyourfirend')}',
                                          style: TextStyle(
                                              color: !themeChange.darkTheme
                                                  ? Color.fromARGB(
                                                      255, 16, 16, 16)
                                                  : Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.redAccent
                                                            .withOpacity(0.3))),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed(Routes.friends);
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('gotofriends'),
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (isRequested) {
                                final snackBar = SnackBar(
                                  backgroundColor: themeChange.darkTheme
                                      ? Color.fromARGB(255, 16, 16, 16)
                                      : Colors.white,
                                  content: Container(
                                    alignment: Alignment.center,
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('therequestissent')} ${snapshot.data!.docs[index]['name']}',
                                          style: TextStyle(
                                              color: !themeChange.darkTheme
                                                  ? Color.fromARGB(
                                                      255, 16, 16, 16)
                                                  : Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.redAccent
                                                            .withOpacity(0.3))),
                                            onPressed: () {},
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate('ok'),
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                updateUi.updateAddIndex(index);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Row(
                                        children: [
                                          Text('Sending..'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          CircularProgressIndicator()
                                        ],
                                      ),
                                    );
                                  },
                                );
                                await RequestFireStore()
                                    .newRequest(RequestFriend(
                                        uidSender: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        uidRecevier: snapshot.data!.docs[index]
                                            ['uid'],
                                        requestId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        imageUrlSender: await UserFireStore()
                                            .getUserImage(FirebaseAuth
                                                .instance.currentUser!.uid),
                                        nameSender: await UserFireStore()
                                            .getUserName(FirebaseAuth
                                                .instance.currentUser!.uid)))
                                    .whenComplete(
                                        () => Navigator.of(context).pop());
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: !isSelected
                                ? Color.fromARGB(255, 20, 19, 19)
                                    .withOpacity(0.2)
                                : Colors.green,
                            child: !isSelected
                                ? Text('Add')
                                : Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
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
    );
  }
}
