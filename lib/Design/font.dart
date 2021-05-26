import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(
          "Font Raleway",
          style: TextStyle(fontFamily: 'Raleway'),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Font Raleway",
          style: TextStyle(fontFamily: 'Raleway'),
        ),
      ),
    );
  }
}
