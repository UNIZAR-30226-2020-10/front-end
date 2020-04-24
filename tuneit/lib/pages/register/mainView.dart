import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/pages/register/login.dart';
import 'package:tuneit/pages/register/register.dart';
import 'package:tuneit/widgets/buttons.dart';




void main() => runApp(MyApp());

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // initialRoute: '/mainview',
      navigatorKey: navigatorKey,
      /*routes:{
        '/mainview':(context) => MainView(),
        '/list':(context) => ShowList(),
        //'/playlists':(context) => PlayLists(),
        '/notificaciones':(context) => Notificaciones(),
        '/login':(context) => Login(),
        '/register':(context) => Register(),
        '/list_podcast':(context) => ShowPodcast(),
      },*/
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepPurple,
        fontFamily: 'RobotoMono',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 25.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'RobotoMono'),
        ),
      ),
      home: MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
              children: <Widget>[
                Flexible(
                  flex: 6,
                  child: new Image(image: new AssetImage('assets/LogoApp.png'),),
                ),
                Container(
                  color: Colors.transparent,
                  height: 30,
                ),
                Flexible(
                    flex: 2,
                    child: gradientButton(context, toLogin, [], 'INICIAR SESIÓN')
                ),
                Container(
                  color: Colors.transparent,
                  height: 30,
                ),
                Flexible(
                    flex: 2,
                    child: gradientButton(context, toRegister, [], 'REGISTRARSE')
                )
              ]
          )
      ),
    );
  }

  void toLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void toRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }
}