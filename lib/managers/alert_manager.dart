import 'package:flutter/material.dart';
import 'package:movies/widgets/alert_error.dart';

class AlertManager {
  final BuildContext context;

  AlertManager({required this.context});
  
  Future<void> showAlert(String? error) {
    AlertError alert = AlertError(error ?? "An undefined Error happened.");
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}