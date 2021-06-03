import 'package:flutter/material.dart';
import 'Forms_/styleTextField.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyCustomForm());
  }
}
