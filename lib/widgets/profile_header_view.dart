import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  final String title;
  const HeaderView({super.key, required this.title});

  static const _style = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color.fromARGB(130, 0, 0, 0));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 30,),
        Text(title.toUpperCase(), style: _style,),
      ],
    );
  }
}