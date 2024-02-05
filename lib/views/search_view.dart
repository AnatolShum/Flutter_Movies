import 'package:flutter/material.dart';
import 'package:movies/widgets/color_scaffold.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return ColoredScaffoldWidget(
      title: 'Movies',
      child: Placeholder(),
      );
  }
}