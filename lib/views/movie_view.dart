import 'package:flutter/material.dart';
import 'package:movies/models/model_movie.dart';

class MovieWidget extends StatelessWidget {
  final Movie movie;
  MovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 390,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return InkWell(
            onTap: () {},
            child: Column(),
          );
        },
      ),
    );
  }
}
