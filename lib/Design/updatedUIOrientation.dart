import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UpdatedUIOrientationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Updated UI Orientation"),
      ),
      backgroundColor: Colors.white,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(
              100,
              (index) => Container(
                color: Colors.black12,
                child: Center(
                  child: Text(
                    "Index $index",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
