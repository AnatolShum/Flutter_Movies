import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/views/login_view.dart';
import 'package:movies/views/register_view.dart';
import 'package:movies/views/verify_view.dart';
import 'package:movies/widgets/loading.dart';
import 'package:movies/widgets/color_gradient.dart';
import 'firebase_options.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const EntryPage(),
      routes: {
        '/login/': (context) => LoginView(),
        '/register/': (context) => RegisterView(),
      },
    ),
  );
}

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  void signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
      } on FirebaseAuthException catch (e) {
       print(e.message);
      }
  }

  @override
  Widget build(BuildContext context) {
    return ColorGradientWidget(
      colors: [
        CupertinoColors.systemBlue,
        CupertinoColors.systemCyan,
      ],
      child: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return Placeholder();
              } else {
                return VerifyEmailView();
              }
            } else {
              return LoginView();
            }
            default:
              return LoadingWidget();
          }
        },
      ),
    );
  }
}


// final MethodChannel keyMethodChannel = MethodChannel('apiKey');

// Future<void> getApiKey() async {
  //   try {
  //     final String result = await keyMethodChannel.invokeMethod('getKey');
  //     print(result);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
