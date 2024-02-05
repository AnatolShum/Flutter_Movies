import 'package:flutter/material.dart';
import 'package:movies/widgets/color_scaffold.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  @override
  Widget build(BuildContext context) {
    return ColoredScaffoldWidget(
      title: 'Movies',
      child: Placeholder(),
      );
  }
}



// final MethodChannel keyMethodChannel = MethodChannel('apiKey');

// Future<void> getApiKey() async {
  //   try {
  //     final String result = await keyMethodChannel.invokeMethod('getKey');
  //     print(result);
  //   } catch (e) {
  //     print(e);
  //   }
  // }