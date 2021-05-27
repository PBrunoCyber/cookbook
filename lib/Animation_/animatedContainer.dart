import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class AnimatedContainerPage extends StatefulWidget {
  @override
  _AnimatedContainerState createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainerPage> {
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadiusGeometry = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Animated Container"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: _borderRadiusGeometry,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          setState(() {
            final random = Random();
            _width = random.nextInt(300).toDouble();
            _height = random.nextInt(300).toDouble();
            _borderRadiusGeometry =
                BorderRadius.circular(random.nextInt(100).toDouble());
            _color = Color.fromRGBO(random.nextInt(256), random.nextInt(256),
                random.nextInt(256), 1);
          });
        },
      ),
    );
  }
}
