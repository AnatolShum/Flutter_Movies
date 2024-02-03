import 'package:flutter/material.dart';

class CellView extends StatelessWidget {
  final String title;
  const CellView({super.key, required this.title});

  static const _style = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromARGB(184, 0, 0, 0));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.withOpacity(0.1),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15),
                Text(title, style: _style,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}