import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/constants/routes.dart';
import 'package:movies/managers/alert_manager.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  AlertManager? alertManager;

  void sendVerification() async {
    alertManager = AlertManager(context: context);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      _pushLogIn();
    } on FirebaseAuthException catch (e) {
      alertManager?.showAlert(e.message);
    } catch (e) {
         alertManager?.showAlert(e.toString());
      }
  }

  void _pushLogIn() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      loginRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
        titleTextStyle: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black),
        centerTitle: true,
        backgroundColor: CupertinoColors.systemMint,
      ),
      backgroundColor: CupertinoColors.systemMint,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please verify your email address.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  color: CupertinoColors.systemIndigo,
                  onPressed: sendVerification,
                  child: Text('Send email verification'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
