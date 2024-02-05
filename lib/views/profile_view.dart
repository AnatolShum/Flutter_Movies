import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/managers/alert_manager.dart';
import 'package:movies/widgets/action_button.dart';
import 'package:movies/widgets/color_scaffold.dart';
import 'package:movies/widgets/profile_cell_view.dart';
import 'package:movies/widgets/profile_header_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AlertManager? alertManager;
  final user = FirebaseAuth.instance.currentUser;
  double _space = 30;

  void signOut() async {
    alertManager = AlertManager(context: context);

    try {
      await FirebaseAuth.instance.signOut();
      _pushLogIn();
    } on FirebaseAuthException catch (e) {
      alertManager?.showAlert(e.message);
    }
  }

  void _pushLogIn() {
    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false);
  }

  String formattedDate() {
    final creationTime = user?.metadata.creationTime;
    if (creationTime != null) {
      final fullDate = DateTime(creationTime.year, creationTime.month, creationTime.day).toString();
      final splittedDare = fullDate.split(' ');
      return splittedDare.first;
    }

    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return ColoredScaffoldWidget(
      title: 'Profile',
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white.withOpacity(0.5),
              ),
              SizedBox(height: _space),
              HeaderView(title: 'name'),
              CellView(title: user?.displayName ?? 'N/A'),
              SizedBox(height: _space),
              HeaderView(title: 'email'),
              CellView(title: user?.email ?? 'N/A'),
              SizedBox(height: _space),
              HeaderView(title: 'member since'),
              CellView(title: formattedDate()),
              SizedBox(height: 44),
              Card(
                color: Colors.white.withOpacity(0.5),
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
