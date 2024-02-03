import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/managers/alert_manager.dart';
import 'package:movies/widgets/action_button.dart';
import 'package:movies/widgets/profile_cell_view.dart';
import 'package:movies/widgets/profile_header_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AlertManager? alertManager;

  double _space = 30;

  void signOut() async {
    alertManager = AlertManager(context: context);

    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      alertManager?.showAlert(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderView(title: 'name'),
            CellView(title: 'User'),
            SizedBox(height: _space),
            HeaderView(title: 'email'),
            CellView(title: 'Email'),
            SizedBox(height: _space),
            HeaderView(title: 'member since'),
            CellView(title: '01/01/2024'),
            SizedBox(height: 44),
            Card(
              color: Colors.grey.withOpacity(0.1),
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionButton(
                          onPressed: signOut,
                          title: 'Sign Out',
                          titleColor: CupertinoColors.systemRed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
