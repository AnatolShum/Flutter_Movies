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
  List<DatabaseFavourites> _favourites = [];
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
                      if (snapshot.hasData) {
                        _favourites = snapshot.data as List<DatabaseFavourites>;
                        return ListView.builder(
                        itemCount: _favourites.length,
                        itemBuilder: (context, index) {
                          final item = _favourites[index];
                          return Placeholder();
                        },
                        );
                      } else {
                        return Center(
                        child: CircularProgressIndicator(),
                      );
                      }
                    default:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
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
