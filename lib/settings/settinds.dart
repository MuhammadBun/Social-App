import 'package:facebook_app/Authentication/auth.dart';
import 'package:facebook_app/Widgets/Auth/sign_in.dart';
import 'package:facebook_app/database/Firebase%20Firestore/firestor_services.dart';
import 'package:facebook_app/routes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../app_loclization.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final authChange = Provider.of<AuthProvider>(context);
    LanguageProvider languageProvider = Provider.of(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
              color: themeChange.darkTheme
                  ? Color.fromARGB(255, 35, 35, 35)
                  : Colors.grey,
              height: 1),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.translate('darkmode')),
              trailing: IconButton(
                  onPressed: () {
                    themeChange.darkTheme = !themeChange.darkTheme;
                  },
                  icon: Icon(Icons.dark_mode)),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.requests);
              },
              title: Text(AppLocalizations.of(context)!.translate('requests')),
              trailing: StreamBuilder(
                stream:
                    FireStoreServices.instance.getNumOfRequests().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: snapshot.data == 0 ? Colors.grey : Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        '${snapshot.data}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return Text('');
                  }
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.translate('language')),
              trailing: Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        languageProvider.updateLanguage('en');
                      },
                      child: Text("English",
                          style: TextStyle(color: Colors.white)),
                      color: themeChange.darkTheme
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        languageProvider.updateLanguage('ar');
                      },
                      child:
                          Text('Arabic', style: TextStyle(color: Colors.white)),
                      color: themeChange.darkTheme
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey,
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: authChange.status == Status.unauthenticated
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListTile(
                    onTap: () {
                      authChange.signOut();
                    },
                    title: Text(
                        AppLocalizations.of(context)!.translate('singout')),
                    trailing: IconButton(
                        onPressed: () {
                          authChange.signOut();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return SignIn();
                            },
                          ), (route) => false);
                          FireStoreServices.instance.clear();
                        },
                        icon: Icon(
                          Icons.output_sharp,
                          color: Colors.red,
                        )),
                  ),
          )
        ],
      ),
    );
  }
}
