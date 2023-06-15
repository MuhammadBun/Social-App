import 'package:facebook_app/Widgets/Animation/loading.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_user.dart';
import 'package:facebook_app/providers/language_provider.dart';

import 'package:facebook_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../app_loclization.dart';
import '../../database/Firebase Firestore/firestor_posts.dart';
import '../../database/Firebase Firestore/firestor_services.dart';

import '../../providers/theme_provider.dart';
import '../../providers/update_ui.dart';

class ListPostFriends extends StatefulWidget {
  const ListPostFriends({Key? key}) : super(key: key);

  @override
  State<ListPostFriends> createState() => _ListPostFriendsState();
}

class _ListPostFriendsState extends State<ListPostFriends> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      body: Column(
        textDirection: TextDirection.ltr,
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
              color: themeChange.darkTheme
                  ? Color.fromARGB(255, 35, 35, 35)
                  : Colors.grey,
              height: 1),
          Container(
            height: 100,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: themeChange.darkTheme
                            ? Color.fromARGB(255, 35, 35, 35)
                            : Colors.grey,
                        width: 10))),
            child: FutureBuilder(
              future: PostFireStore().getImgaePublisher(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${snapshot.data}'),
                        radius: 25, // Image radius
                        backgroundColor: Colors.grey,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.newPost);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('whatinyourmind'),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const LoadingPosts();
                }
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: PostFireStore().getFriendsPosts().asStream(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                            color: themeChange.darkTheme
                                ? Color(0xFF151514)
                                : Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: themeChange.darkTheme
                                        ? Color.fromARGB(255, 19, 19, 19)
                                        : Colors.grey,
                                    width: 10))),
                        child: Column(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              textDirection: TextDirection.ltr,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data!.docs[index]['imagePublicsher']),
                                  radius: 25, // Image radius
                                  backgroundColor: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['namePublicsher'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      textDirection: TextDirection.ltr,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(snapshot.data!.docs[index]['date'],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textDirection: TextDirection.ltr),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          snapshot.data!.docs[index]['isPublic']
                                              ? Icons.public
                                              : Icons.group,
                                          size: 15,
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10),
                              child: ReadMoreText(
                                snapshot.data!.docs[index]['content'],
                                trimLines: 2,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: AppLocalizations.of(context)!
                                    .translate('show'),
                                trimExpandedText: AppLocalizations.of(context)!
                                    .translate('back'),
                                moreStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                locale: LanguageProvider().appLocale,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 0.4,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      child: Icon(
                                        FontAwesomeIcons.solidThumbsUp,
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Color.fromARGB(255, 123, 123, 123)
                                                .withOpacity(0.6),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('like'),
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(FontAwesomeIcons.solidComment,
                                          color: themeChange.darkTheme
                                              ? Colors.white
                                              : Color.fromARGB(
                                                      255, 123, 123, 123)
                                                  .withOpacity(0.6)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('comment'),
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      child: Icon(FontAwesomeIcons.share,
                                          color: themeChange.darkTheme
                                              ? Colors.white
                                              : Color.fromARGB(
                                                      255, 123, 123, 123)
                                                  .withOpacity(0.6)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('share'),
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            )
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
            ),
          )
        ],
      ),
    );
  }
}
