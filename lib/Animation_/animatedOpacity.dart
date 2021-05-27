import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedOpacityPage extends StatefulWidget {
  @override
  _AnimatedOpacityState createState() => _AnimatedOpacityState();
}

class _AnimatedOpacityState extends State<AnimatedOpacityPage> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Animated Opacity"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          duration: Duration(seconds: 1),
          curve: Curves.ease,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          setState(() {
            _visible = !_visible;
          });
        },
      ),
    );
  }
}
