import 'package:flutter/material.dart';
import 'package:movies/views/entry_view.dart';
import 'package:movies/views/forgot_view.dart';
import 'package:movies/views/login_view.dart';
import 'package:movies/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const EntryPage(),
      routes: {
        '/login/': (context) => LoginView(),
        '/register/': (context) => RegisterView(),
        '/forgot/':(context) => ForgotView(),
      },
    ),
  );
}
