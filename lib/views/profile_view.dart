import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/managers/alert_manager.dart';
import 'package:movies/widgets/action_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AlertManager? alertManager;

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
            CellView(child: const Text('User')),
            ActionButton(
                  onPressed: signOut,
                  title: 'Sign Out',
                  titleColor: CupertinoColors.systemRed,
                ),
          ],
        ),
      ),
    );
  }
}

class CellView extends StatelessWidget {
  final Widget child;
  const CellView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.withOpacity(0.1),
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: child,
          ),
        ],
      ),
    );
  }
}