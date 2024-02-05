import 'package:flutter/material.dart';
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
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
        '/verify/':(context) => const VerifyEmailView(),
        '/forgot/':(context) => const ForgotView(),
        '/moviesTabBar/':(context) => const MoviesTabBar(),
      },
    ),
  );
}
