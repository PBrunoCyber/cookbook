import 'package:flutter/material.dart';
import 'Effects_/parallaxEffect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ParallaxRecipe(),
    );
  }
}
