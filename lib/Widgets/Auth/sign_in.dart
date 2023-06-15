import 'package:app_settings/app_settings.dart';
import 'package:facebook_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../../../app_loclization.dart';
import '../../Authentication/auth.dart';
import '../../Services/connection.dart';
import '../../Services/manage_input.dart';
import '../../providers/theme_provider.dart';
import '../Static/text_form.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isVisibe = false;
  ScrollController? controller;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    controller = ScrollController();

    KeyboardVisibilityController().onChange.listen((bool event) {
      if (event) {
        setState(() {
          isVisibe = true;
        });
      } else {
        setState(() {
          isVisibe = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // this avoids the overflow error

      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              AnimatedOpacity(
                onEnd: () {
                  controller!.animateTo(400,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOut);
                },
                opacity: !isVisibe ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: Center(
                  child: SvgPicture.asset(
                    'images/facebook_login.svg',
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('welcomto'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('socialapp'),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: themeChange.darkTheme
                          ? const Color.fromARGB(255, 13, 13, 13)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.normal,
                            color: themeChange.darkTheme
                                ? const Color.fromARGB(255, 13, 13, 13)
                                : Colors.black.withOpacity(0.1),
                            spreadRadius: 0,
                            offset: Offset(0, 0))
                      ]),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CostumTextFormFields(
                            hintText: AppLocalizations.of(context)!
                                .translate('loginTxtEmail'),
                            icon: null,
                            onChanged: (value) {},
                            onSaved: (value) {},
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "null";
                              }

                              return null;
                            },
                            controller: _emailController),
                        CostumTextFormFields(
                            hintText: AppLocalizations.of(context)!
                                .translate('loginTxtPassword'),
                            icon: null,
                            onChanged: (value) {},
                            onSaved: (value) {},
                            validator: (text) {
                              if (text!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .translate('required');
                              }

                              return null;
                            },
                            controller: _passwordController),
                        const SizedBox(
                          height: 20,
                        ),
                        authProvider.status == Status.authenticating
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: themeChange.darkTheme
                                    ? const Color.fromARGB(255, 28, 28, 28)
                                    : const Color(0xFF151514),
                                textColor: themeChange.darkTheme
                                    ? Colors.white
                                    : Colors.white,
                                onPressed: () async {
                                  if (await AppConnection()
                                      .checkConnectivityState()) {
                                    await ValidatorInput().isValidForSign(
                                      key: _formKey,
                                      auth: authProvider,
                                      context: context,
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                    );
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
                                              child: Text(AppLocalizations.of(
                                                      context)!
                                                  .translate('presstocheck')),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text(AppLocalizations.of(context)!
                                    .translate('signIn')),
                                minWidth: 150,
                                height: 50,
                              ),
                        Row(
                          children: [
                            Text(AppLocalizations.of(context)!
                                .translate('haveacc')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, Routes.register);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('presshere'),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
