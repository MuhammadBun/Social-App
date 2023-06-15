import 'package:facebook_app/Authentication/auth.dart';

import 'package:facebook_app/Services/validation.dart';

import 'package:facebook_app/providers/language_provider.dart';
import 'package:facebook_app/providers/search_provider.dart';
import 'package:facebook_app/providers/theme_provider.dart';
import 'package:facebook_app/providers/update_ui.dart';
import 'package:facebook_app/providers/update_upload.dart';
import 'package:facebook_app/routes.dart';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_loclization.dart';
import 'themes/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  LanguageProvider languageChangeProvider = LanguageProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        !await themeChangeProvider.darkThemePreferences.getTheme();
  }

  void getCurrentAppLanguage() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    getCurrentAppLanguage();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateUploadedImage(),
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateUi(),
        ),
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          return languageChangeProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          return SearchItemProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return ValidationPassAndEmail();
        }),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return Consumer<LanguageProvider>(
            builder: (context, value, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                routes: Routes.routes,
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                locale: value.appLocale,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'AR'),
                ],
                localizationsDelegates: const [
                  //A class which loads the translations from JSON files
                  AppLocalizations.delegate,
                  //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                  GlobalMaterialLocalizations.delegate,
                  //Built-in localization for text direction LTR/RTL
                  GlobalWidgetsLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  //check if the current device locale is supported or not
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode ||
                        supportedLocale.countryCode == locale?.countryCode) {
                      return supportedLocale;
                    }
                  }
                  //if the locale from the mobile device is not supported yet,
                  //user the first one from the list (in our case, that will be English)
                  return supportedLocales.first;
                },
              );
            },
          );
        },
      ),
    );
  }
}
