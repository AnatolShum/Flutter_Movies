import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({super.key});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        titleTextStyle: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed('/login/');
          },
        ),
        centerTitle: true,
        backgroundColor: CupertinoColors.systemOrange,
      ),
      backgroundColor: CupertinoColors.systemOrange,
    );
  }
}