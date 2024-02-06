import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/constants/routes.dart';
import 'package:movies/managers/alert_manager.dart';
import '../firebase_options.dart';
// import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AlertManager? alertManager;

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    alertManager = AlertManager(context: context);
    if (_email.text.trim().isEmpty || _password.text.trim().isEmpty) {
      alertManager?.showAlert('Please fill in all fields.');
      return false;
    }

    if (!_email.text.contains('@') || !_email.text.contains('.')) {
      alertManager?.showAlert('Please enter valid email.');
      return false;
    }

    return true;
  }

  void logIn() async {
    if (_validate()) {
      alertManager = AlertManager(context: context);

      final email = _email.text;
      final password = _password.text;

      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            _pushTabBar();
          } else {
            alertManager?.showAlert('Please verify your email address.');
          }
        }
      } on FirebaseAuthException catch (e) {
        alertManager?.showAlert(e.message);
      } catch (e) {
         alertManager?.showAlert(e.toString());
      }
    }
  }

  void _pushTabBar() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      tabBarRoute,
      (route) => false,
    );
  }

  void _pushForgot() {
     Navigator.of(context).pushNamedAndRemoveUntil(
      forgotRoute,
      (route) => false,
      );
  }

  void _pushRegister() {
      Navigator.of(context).pushNamedAndRemoveUntil(
        registerRoute, 
        (route) => false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        titleTextStyle: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black),
        backgroundColor: CupertinoColors.systemBlue,
      ),
      backgroundColor: CupertinoColors.systemBlue,
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Card(
                    color: Colors.white.withOpacity(0.5),
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _email,
                                decoration: const InputDecoration(
                                    hintText: 'Email address'),
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextField(
                                controller: _password,
                                decoration:
                                    const InputDecoration(hintText: 'Password'),
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CupertinoButton(
                                    padding: EdgeInsets.only(left: 0),
                                    onPressed: _pushForgot,
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                          color: Color.fromARGB(190, 0, 0, 0),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              padding: EdgeInsets.all(0),
                              color: CupertinoColors.systemRed,
                              onPressed: logIn,
                              child: const Text('Login'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  CupertinoButton(
                    onPressed: _pushRegister,
                    child: const Text(
                      'Create an account',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              );
            default:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CupertinoActivityIndicator(
                      radius: 14,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Loading...",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
