import 'package:facebook_app/database/Firebase%20Firestore/firestor_posts.dart';
import 'package:facebook_app/models/posts.dart';
import 'package:facebook_app/providers/update_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../app_loclization.dart';
import '../../providers/theme_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late TextEditingController postController;

  @override
  void initState() {
    postController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    postController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final uiChange = Provider.of<UpdateUi>(context);

    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor:
                themeChange.darkTheme ? Color(0xFF151514) : Colors.white,
            leadingWidth: 200,
            leading: InkWell(
              onTap: () async {
                if (postController.text.isEmpty) {
                  Navigator.of(context).pop();
                } else {
                  showMenu(themeChange, uiChange);
                }
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 16,
                    color: !themeChange.darkTheme
                        ? Color(0xFF151514)
                        : Colors.white,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate('createpost'),
                    style: TextStyle(
                        fontSize: 20,
                        color: !themeChange.darkTheme
                            ? Color(0xFF151514)
                            : Colors.white),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<UpdateUi>(
                builder: (context, value, child) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: MaterialButton(
                      onPressed: uiChange.getActive
                          ? () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .translate('posting')),
                                    content: Container(
                                        height: 150,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        )),
                                  );
                                },
                              );
                              await PostFireStore()
                                  .setPost(Post(
                                      publisherUid: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      content: postController.text,
                                      date: DateFormat.yMd()
                                          .add_jm()
                                          .format(DateTime.now()),
                                      imageUrl: '',
                                      postId: documentIdFromCurrentDate(),
                                      isPublic:
                                          value.getValue == 0 ? false : true,
                                      imagePublicsher: await PostFireStore()
                                          .getImgaePublisher(),
                                      namePublicsher: await PostFireStore()
                                          .getNamePublisher()))
                                  .whenComplete(() {
                                uiChange.updatePostButton(false);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              });
                            }
                          : null,
                      child: Text(
                        AppLocalizations.of(context)!.translate('post'),
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      color: value.getActive
                          ? Color.fromARGB(255, 23, 130, 217)
                          : Colors.grey,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Consumer<UpdateUi>(
            builder: (context, value, child) {
              return SlidingUpPanel(
                defaultPanelState: PanelState.OPEN,
                color: themeChange.darkTheme
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white,
                panel: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: Icon(Icons.keyboard_arrow_up_sharp),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(AppLocalizations.of(context)!
                            .translate('photovideo')),
                        leading: Icon(
                          FontAwesomeIcons.images,
                          color: Colors.green,
                        ),
                        minLeadingWidth: 5,
                      ),
                      decoration: BoxDecoration(),
                    ),
                    Container(
                      child: ListTile(
                        title: Text(
                            AppLocalizations.of(context)!.translate('live')),
                        leading: Icon(
                          FontAwesomeIcons.video,
                          color: Colors.red,
                        ),
                        minLeadingWidth: 5,
                      ),
                      decoration: BoxDecoration(),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: value.getValue,
                                onChanged: (value) {
                                  uiChange.updateValue(value as int);
                                  print(value);
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(AppLocalizations.of(context)!
                                  .translate('firends'))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: value.getValue,
                                onChanged: (value) {
                                  uiChange.updateValue(value as int);
                                  print(value);
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(AppLocalizations.of(context)!
                                  .translate('public'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                    child: TextFormField(
                      controller: postController,
                      onChanged: (value) async {
                        await context
                            .read<UpdateUi>()
                            .updatePostButton(value.isNotEmpty);
                      },
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "null";
                        }

                        return null;
                      },
                      cursorColor: Colors.grey,
                      maxLines: 100,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          hintText: AppLocalizations.of(context)!
                              .translate('taphere'),
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          border: InputBorder.none),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
              );
            },
          )),
      onWillPop: () async {
        if (postController.text.isEmpty) {
          return true;
        } else {
          return showMenu(themeChange, uiChange);
        }
      },
    );
  }

  showMenu(DarkThemeProvider themeChange, UpdateUi uiChange) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: themeChange.darkTheme
                  ? Colors.black.withOpacity(0.3)
                  : Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 36,
                ),
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: themeChange.darkTheme
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white,
                        ),
                        child: Stack(
                          alignment: Alignment(0, 0),
                          children: <Widget>[
                            Positioned(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .translate('saveasdraft'),
                                    ),
                                    leading: Icon(
                                      Icons.drafts_sharp,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .translate('continue'),
                                    ),
                                    leading: Icon(
                                      Icons.arrow_back,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .translate('ignore'),
                                    ),
                                    leading: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      uiChange.updatePostButton(false);

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
              ],
            ),
          );
        });
  }
}
