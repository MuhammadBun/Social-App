import 'package:facebook_app/providers/update_upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Services/manage_input.dart';
import '../../app_loclization.dart';
import '../../database/Firebase Storage/storage.dart';
import '../../providers/theme_provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final Storage storage = Storage();
  String imageUrl = '';
  late TextEditingController _name;
  late TextEditingController _bio;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name = TextEditingController();
    _bio = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final ImageProvider imageProvider;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Consumer<UpdateUploadedImage>(
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        textDirection: TextDirection.ltr,
                        children: [
                          FutureBuilder(
                            future: storage.downloadURL(
                                FirebaseAuth.instance.currentUser!.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CircleAvatar(
                                  backgroundImage:
                                      NetworkImage('${snapshot.data}'),
                                  radius: 60, // Image radius
                                );
                              } else {
                                return Container(
                                  alignment: Alignment.center,
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      color: themeChange.darkTheme
                                          ? Colors.black.withOpacity(0.4)
                                          : Colors.grey.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(70)),
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () async {
                              final results =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg'],
                              );

                              if (results == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('No file selected.')));
                                return;
                              }

                              final path = results.files.single.path!;

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Container(
                                        width: 100,
                                        height: 80,
                                        alignment: Alignment.center,
                                        child: Text('Uploading...')),
                                  );
                                },
                              );
                              await storage
                                  .uploadFile(path,
                                      FirebaseAuth.instance.currentUser!.uid)
                                  .whenComplete(
                                      () => Navigator.of(context).pop());

                              final imageUrls = await storage.downloadURL(
                                  FirebaseAuth.instance.currentUser!.uid);

                              imageUrl = imageUrls;
                              await context
                                  .read<UpdateUploadedImage>()
                                  .updateImageUrl(imageUrls);
                            },
                            child: Container(
                                width: 130,
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('selectphoto'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 5, left: 15, right: 15),
                child: TextFormField(
                  cursorColor: Colors.grey,
                  controller: _name,
                  autofocus: true,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "null";
                    }

                    return null;
                  },
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
                      hintText: AppLocalizations.of(context)!.translate('name'),
                      fillColor: Color.fromARGB(15, 102, 102, 102),
                      filled: true,
                      hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      border: InputBorder.none),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
                child: TextFormField(
                  controller: _bio,
                  onSaved: (value) {},
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "null";
                    }

                    return null;
                  },
                  cursorColor: Colors.grey,
                  maxLines: 5,
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
                      hintText: AppLocalizations.of(context)!.translate('bio'),
                      fillColor: Color.fromARGB(15, 102, 102, 102),
                      filled: true,
                      hintStyle: TextStyle(fontWeight: FontWeight.w300),
                      border: InputBorder.none),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                            width: 100,
                            height: 80,
                            alignment: Alignment.center,
                            child: Text('Wait..')),
                      );
                    },
                  );
                  await ValidatorInput().isValidForUserInfo(
                    context: context,
                    key: _formKey,
                    bioController: _bio,
                    nameController: _name,
                    imageUrl: imageUrl == ""
                        ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
                        : imageUrl,
                  );
                },
                child: Container(
                    width: 130,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('start'),
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
