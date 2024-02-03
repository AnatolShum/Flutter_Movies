import 'package:flutter/material.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies'),),
      backgroundColor: Colors.cyan,
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