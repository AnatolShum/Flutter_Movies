import 'package:flutter/material.dart';
import 'package:movies/views/entry_view.dart';
import 'package:movies/views/login_view.dart';
import 'package:movies/views/register_view.dart';
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
