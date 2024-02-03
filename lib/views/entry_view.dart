import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies/firebase_options.dart';
import 'package:movies/views/bottom_bar_view.dart';
import 'package:movies/views/login_view.dart';
import 'package:movies/views/verify_view.dart';
import 'package:movies/widgets/color_gradient.dart';
import 'package:movies/widgets/loading.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

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
                return MoviesTabBar();
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