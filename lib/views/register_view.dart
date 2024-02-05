import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../managers/alert_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  AlertManager? alertManager;

  late final TextEditingController _email;
  late final TextEditingController _userName;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _userName = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    alertManager = AlertManager(context: context);
    if (_email.text.trim().isEmpty &&
        _userName.text.trim().isEmpty &&
        _password.text.trim().isEmpty) {
      alertManager?.showAlert('Please fill in all fields.');
      return false;
    }

    if (!_email.text.contains('@') || !_email.text.contains('.')) {
      alertManager?.showAlert('Please enter valid email.');
      return false;
    }

    if (_password.text.length < 6) {
      alertManager?.showAlert('Minimum password length is 6 characters.');
      return false;
    }

    return true;
  }

  void signUp() async {
    if (_validate()) {
      alertManager = AlertManager(context: context);
      final email = _email.text;
      final userName = _userName.text;
      final password = _password.text;

      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        userCredential.user?.updateDisplayName(userName);
        _pushVerify();
      } on FirebaseAuthException catch (e) {
        alertManager?.showAlert(e.message);
      }
    }
  }

  void _pushVerify() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/verify/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        titleTextStyle: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black),
        leadingWidth: 80,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Login',
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/login/');
          },
        ),
        centerTitle: true,
        backgroundColor: CupertinoColors.systemGreen,
      ),
      backgroundColor: CupertinoColors.systemGreen,
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
                                controller: _userName,
                                decoration: const InputDecoration(
                                    hintText: 'User name'),
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.name,
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
                            ],
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              padding: EdgeInsets.all(0),
                              color: CupertinoColors.systemBlue,
                              onPressed: () {
                                signUp();
                              },
                              child: const Text('Register'),
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
