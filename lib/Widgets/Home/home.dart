import 'package:app_settings/app_settings.dart';
import 'package:facebook_app/Widgets/Home/search.dart';
import 'package:facebook_app/Widgets/Posts/public_posts.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_posts.dart';

import 'package:facebook_app/providers/update_ui.dart';

import 'package:facebook_app/routes.dart';
import 'package:facebook_app/settings/settinds.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../Services/connection.dart';
import '../../app_loclization.dart';

import '../../providers/theme_provider.dart';

import '../Friend Request/friends_list.dart';
import '../Posts/list_post_friends.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TabController? tabController = DefaultTabController.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final updateUi = Provider.of<UpdateUi>(context);

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Text(
                        "Social App",
                        style: TextStyle(
                            color: themeChange.darkTheme
                                ? Colors.white
                                : Colors.blue,
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        FontAwesomeIcons.shareNodes,
                        color:
                            themeChange.darkTheme ? Colors.white : Colors.blue,
                      )
                    ],
                  ),
                ),
                elevation: 10,
                pinned: true,
                floating: true,
                snap: true,
                bottom: TabBar(
                    onTap: (value) async {
                      await context.read<UpdateUi>().updateTapColorIcon(value);
                    },
                    unselectedLabelColor: Colors.grey,
                    controller: tabController,
                    indicator: MaterialIndicator(
                        height: 3,
                        topLeftRadius: 5,
                        topRightRadius: 5,
                        bottomLeftRadius: 1,
                        bottomRightRadius: 1,
                        horizontalPadding: 10,
                        tabPosition: TabPosition.bottom,
                        color: Colors.blue),
                    tabs: [
                      Consumer<UpdateUi>(
                        builder: (context, value, child) {
                          return Tab(
                            child: Icon(
                              size: value.getTabCount == 0 ? 30 : 25,
                              Icons.public,
                              color: value.getTabCount == 0
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                      Consumer<UpdateUi>(
                        builder: (context, value, child) {
                          return Tab(
                            child: Icon(
                              size: value.getTabCount == 1 ? 30 : 25,
                              Icons.home,
                              color: value.getTabCount == 1
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                      Consumer<UpdateUi>(
                        builder: (context, value, child) {
                          return Tab(
                            child: Icon(
                              Icons.notifications,
                              color: value.getTabCount == 2
                                  ? Colors.blue
                                  : Colors.grey,
                              size: value.getTabCount == 2 ? 30 : 25,
                            ),
                          );
                        },
                      ),
                      Consumer<UpdateUi>(
                        builder: (context, value, child) {
                          return Tab(
                            child: Icon(
                              size: value.getTabCount == 3 ? 30 : 25,
                              Icons.supervised_user_circle_rounded,
                              color: value.getTabCount == 3
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                      Consumer<UpdateUi>(
                        builder: (context, value, child) {
                          return Tab(
                            child: Icon(
                              size: value.getTabCount == 4 ? 30 : 25,
                              Icons.menu,
                              color: value.getTabCount == 4
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ]),
              )
            ],
            body: TabBarView(children: [
              ListPublicPosts(),
              ListPostFriends(),
              Center(
                child: Icon(
                  Icons.notifications,
                  size: 200,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
              FriendsScreen(),
              SettingsScreen(),
            ]),
          ),
          floatingActionButton: Column(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        color:
                            !themeChange.darkTheme ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Icon(
                      Icons.search,
                      color: themeChange.darkTheme
                          ? Color(0xFF151514)
                          : Colors.white,
                      size: 25,
                    ),
                  ),
                  onTap: () async {
                    if (await AppConnection().checkConnectivityState()) {
                      updateUi.updateRemoveIndex(updateUi.getListOfIndex);
                      showSearch(
                          context: context,
                          delegate: UserSearch(
                              hintText: AppLocalizations.of(context)!
                                  .translate('search')));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(AppLocalizations.of(context)!
                                .translate('checkinternet')),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            height: 70,
                                            child: CircularProgressIndicator()),
                                      );
                                    },
                                  );
                                  await AppSettings.openWIFISettings(
                                      asAnotherTask: true);
                                  Navigator.of(context).pop();

                                  Navigator.of(context).pop();
                                },
                                child: Text(AppLocalizations.of(context)!
                                    .translate('presstocheck')),
                              )
                            ],
                          );
                        },
                      );
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              InkWell(
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        color:
                            !themeChange.darkTheme ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Icon(
                      Icons.add,
                      color: themeChange.darkTheme
                          ? Color(0xFF151514)
                          : Colors.white,
                      size: 25,
                    ),
                  ),
                  onTap: () async {
                    if (await AppConnection().checkConnectivityState()) {
                      Navigator.pushNamed(context, Routes.newPost);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(AppLocalizations.of(context)!
                                .translate('checkinternet')),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            height: 70,
                                            child: CircularProgressIndicator()),
                                      );
                                    },
                                  );
                                  await AppSettings.openWIFISettings(
                                      asAnotherTask: true);
                                  Navigator.of(context).pop();

                                  Navigator.of(context).pop();
                                },
                                child: Text(AppLocalizations.of(context)!
                                    .translate('presstocheck')),
                              )
                            ],
                          );
                        },
                      );
                    }
                  }),
            ],
          )),
    );
  }
}
