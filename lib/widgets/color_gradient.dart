import 'package:flutter/material.dart';

class ColorGradientWidget extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  const ColorGradientWidget({super.key, required this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
            ),
        ),
        child: child,
      ),
    );
  }
}
