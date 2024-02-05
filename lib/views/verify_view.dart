import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void sendVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    user?.sendEmailVerification();
    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please verify your email address.'),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              color: CupertinoColors.activeBlue,
              onPressed: sendVerification,
              child: Text('Send email verification'),
            ),
          ],
        ),
      ),
    );
  }
}