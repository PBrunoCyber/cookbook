import 'package:flutter/material.dart';
import 'Effects_/nestedNavigationFlow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        late Widget page;
        if (settings.name == '/')
          page = Home();
        else if (settings.name!.startsWith('/setup/')) {
          final subroute = settings.name!.substring('/setup/'.length);
          page = SetupPage(subRouteName: subroute);
        } else {
          throw Exception('Unknown route: ${settings.name}');
        }
        return MaterialPageRoute<dynamic>(
          builder: (context) => page,
          settings: settings,
        );
      },
    );
  }
}
