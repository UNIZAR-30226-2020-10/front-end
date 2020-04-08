import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/pages/login.dart';
import 'package:tuneit/pages/register.dart';
import 'package:tuneit/widgets/buttons.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                height: 20,
              ),
              Flexible(
                  flex: 2,
                  child: gradientButton(context, toRegister, [], 'REGISTRARSE')
              )
            ]
        )
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