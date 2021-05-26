import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Drawer"),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black26),
              child: Text("Drawer Page"),
            ),
            ListTile(
              leading:
                  CircleAvatar(backgroundColor: Colors.black26, maxRadius: 20),
              title: Text("Inicio"),
            ),
            ListTile(
              leading:
                  CircleAvatar(backgroundColor: Colors.black26, maxRadius: 20),
              title: Text("Estatísticas"),
            ),
          ],
        ),
      ),
    );
  }
}
