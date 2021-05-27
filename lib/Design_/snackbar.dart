import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("SnackBar Widget"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: CupertinoButton.filled(
          child: Text("Show SnackBar"),
          onPressed: () {
            final snackbar = SnackBar(
              content: Text("Yah! A SnackBar"),
              action: SnackBarAction(label: "Ok", onPressed: () {}),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          },
        ),
      ),
    );
  }
}
