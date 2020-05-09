import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/notificaciones/PushProvider.dart';
import 'package:tuneit/pages/register/login.dart';
import 'package:tuneit/pages/register/register.dart';
import 'package:tuneit/widgets/buttons.dart';


class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  @override
  void initState() {
    // TODO: implement initState
    var pus1=PushProvider();
    pus1.initNotifications();
    super.initState();
  }
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
                    child: gradientButton(context, toLogin, [], 'INICIAR SESIÓN', 50, 230, 20)
                ),
                Container(
                  color: Colors.transparent,
                  height: 30,
                ),
                Flexible(
                    flex: 2,
                    child: gradientButton(context, toRegister, [], 'REGISTRARSE', 50, 230, 20)
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