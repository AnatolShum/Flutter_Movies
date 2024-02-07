import 'package:flutter/cupertino.dart';
import 'package:movies/services/auth/auth_service.dart';
import 'package:movies/views/bottom_bar_view.dart';
import 'package:movies/views/login_view.dart';
import 'package:movies/views/verify_view.dart';
import 'package:movies/widgets/loading.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          final user = AuthService.firebase().currentUser;
          if (user != null) {
            if (user.isEmailVerified) {
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
    );
  }
}