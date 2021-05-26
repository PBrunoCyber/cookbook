import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Route _routePage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PageTransition2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curves = Curves.easeOut;
      var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curves));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class PageTransition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Page 1"),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: CupertinoButton.filled(
        child: Text("Go"),
        onPressed: () => Navigator.of(context).push(_routePage()),
      )),
    );
  }
}

class PageTransition2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Page 2"),
        backgroundColor: Colors.black12,
      ),
      backgroundColor: Colors.blue,
    );
  }
}
