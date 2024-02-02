
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/managers/alert_manager.dart';
import '../firebase_options.dart';

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
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        alertManager?.showAlert(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login'),
          titleTextStyle: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black)
              ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration:
                        const InputDecoration(hintText: 'Email address'),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(hintText: 'Password'),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  SizedBox(height: 10,),
                  CupertinoButton(
                    color: Colors.blue,
                    onPressed: () {
                      logIn();
                    },
                    child: const Text('Login'),
                  ),
                  SizedBox(height: 10,),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/register/', 
                        (route) => false);
                    },
                    child: const Text('Register'), 
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


