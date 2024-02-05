import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColoredScaffoldWidget extends StatelessWidget {
  final String? title;
  final Widget child;
  const ColoredScaffoldWidget({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (title != null) ? Text(title!) : null,
        titleTextStyle: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black),
        backgroundColor: CupertinoColors.systemBlue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CupertinoColors.systemBlue,
              CupertinoColors.systemBlue,
              CupertinoColors.systemCyan,
              CupertinoColors.systemCyan,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
