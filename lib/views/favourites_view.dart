import 'package:flutter/material.dart';
import 'package:movies/services/auth/auth_service.dart';
import 'package:movies/services/crud/db_favourite.dart';
import 'package:movies/services/crud/db_service.dart';
import 'package:movies/widgets/color_scaffold.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  DatabaseFavourites? _favourite;
  late final DatabaseService _databaseService;
  String get userEmail => AuthService.firebase().currentUser!.email;
  String get userName => AuthService.firebase().currentUser!.userName;

  @override
  void initState() {
    _databaseService = DatabaseService();
    _databaseService.open();
    super.initState();
  }

  @override
  void dispose() {
    _databaseService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredScaffoldWidget(
      title: 'Favourites',
      child: FutureBuilder(
        future:
            _databaseService.getOrCreateUser(name: userName, email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _databaseService.allFavourites,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Center();
                    default:
                      return Center(child: CircularProgressIndicator(),);
                  }
                },
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
