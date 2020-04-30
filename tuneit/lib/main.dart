import 'package:flutter/material.dart';
import 'package:tuneit/pages/register/mainView.dart';

void main() => runApp(MyApp());

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        fontFamily: 'RobotoMono',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 25.0, fontStyle: FontStyle.italic),
          subtitle: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'RobotoMono'),
        ),
      ),
      home: MainView(),
    );
  }
}