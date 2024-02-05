import 'package:flutter/material.dart';
import 'package:movies/widgets/color_scaffold.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  @override
  Widget build(BuildContext context) {
    return ColoredScaffoldWidget(
      title: 'Movies',
      child: Placeholder(),
      );
  }
}