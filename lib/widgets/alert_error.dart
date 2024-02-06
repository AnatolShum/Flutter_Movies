import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertError extends StatelessWidget {
  final String content;

  AlertError(this.content);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Ok',
            style: TextStyle(color: CupertinoColors.systemBlue),
          ),
        )
      ],
    );
  }
}
