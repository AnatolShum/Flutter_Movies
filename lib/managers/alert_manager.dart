import 'package:flutter/material.dart';
import 'package:movies/widgets/alert_error.dart';

class AlertManager {
  final BuildContext context;

  AlertManager({required this.context});
  
  void showAlert(String? error) {
    AlertError alert = AlertError(error ?? "An undefined Error happened.");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}