import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color? color;
  final Function() onPressed;
  final String title;
  final Color? titleColor;

  const ActionButton({super.key, this.color, required this.onPressed, required this.title, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: color ?? Colors.transparent, 
      onPressed: onPressed,
      child: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: titleColor ?? Colors.black,)), 
      );
  }
}