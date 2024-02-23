import 'package:flutter/material.dart';
import 'package:movies/models/model_movie.dart';
import 'package:movies/services/network/network_service.dart';
import 'package:movies/services/network/network_types.dart';
import 'package:movies/widgets/color_scaffold.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  List<Movie> _nowPlaying = [];
  late NetworkService _networkService;

  @override
  void initState() {
    _networkService = NetworkService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredScaffoldWidget(
      title: 'Movies',
      child: FutureBuilder(
        future: _networkService.fetchMovies(
            type: ArgumentType.nowPlaying, page: 1),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _networkService.allNowPlaying,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        _nowPlaying = snapshot.data as List<Movie>;
                        return ListView.builder(
                          itemCount: _nowPlaying.length,
                          itemBuilder:(context, index) {
                            final item = _nowPlaying[index];
                            final uri = _networkService.getImageUri(item.poster);
                            return Image.network(uri!);
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
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
