import 'package:flutter/material.dart';
import 'package:movies/constants/routes.dart';
import 'package:movies/views/bottom_bar_view.dart';
import 'package:movies/views/entry_view.dart';
import 'package:movies/views/forgot_view.dart';
import 'package:movies/views/login_view.dart';
import 'package:movies/views/register_view.dart';
import 'package:movies/views/verify_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const EntryPage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyRoute: (context) => const VerifyEmailView(),
        forgotRoute: (context) => const ForgotView(),
        tabBarRoute: (context) => const MoviesTabBar(),
      },
    ),
  );
}
