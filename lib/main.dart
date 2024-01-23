import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    if (_email.text.trim().isEmpty || _password.text.trim().isEmpty) {
      _showAlert('Please fill in all fields.');
      return false;
    }

    if (!_email.text.contains('@') || !_email.text.contains('.')) {
      _showAlert('Please enter valid email.');
      return false;
    }

    return true;
  }

  void logIn() async {
    if (_validate()) {
      final email = _email.text;
      final password = _password.text;

      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        _showAlert(e.message);
      }
    }
  }

  void _showAlert(String? error) {
    AlertError alert = AlertError(error ?? "An undefined Error happened.");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login'),
          titleTextStyle: TextStyle(
              fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black)),
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
                  CupertinoButton(
                    color: Colors.blue,
                    onPressed: () {
                      logIn();
                    },
                    child: const Text('Login'),
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

class AlertError extends StatelessWidget {
  final String content;

  AlertError(this.content);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Text(content),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              'Ok',
              style: TextStyle(color: CupertinoColors.systemBlue),
            ))
      ],
    );
  }
}
