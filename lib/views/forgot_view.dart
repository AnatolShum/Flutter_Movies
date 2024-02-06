import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/constants/routes.dart';
import 'package:movies/managers/alert_manager.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({super.key});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  AlertManager? alertManager;

  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  bool _validate() {
    alertManager = AlertManager(context: context);
    if (_email.text.trim().isEmpty) {
      alertManager?.showAlert('Please enter email.');
      return false;
    }

    if (!_email.text.contains('@') || !_email.text.contains('.')) {
      alertManager?.showAlert('Please enter valid email.');
      return false;
    }

    return true;
  }

  void resetPassword() async {
    if (_validate()) {
      alertManager = AlertManager(context: context);

      final email = _email.text;

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        _pushLogIn();
      } on FirebaseAuthException catch (e) {
        alertManager?.showAlert(e.message);
      } catch (e) {
         alertManager?.showAlert(e.toString());
      }
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
        title: const Text('Reset password'),
        titleTextStyle: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w700, color: Colors.black),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed(loginRoute);
          },
        ),
        centerTitle: true,
        backgroundColor: CupertinoColors.systemOrange,
      ),
      backgroundColor: CupertinoColors.systemOrange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Colors.white.withOpacity(0.5),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _email,
                        decoration:
                            const InputDecoration(hintText: 'Email address'),
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      padding: EdgeInsets.all(0),
                      color: CupertinoColors.systemPink,
                      onPressed: () {
                        resetPassword();
                      },
                      child: const Text('Send password reset'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
