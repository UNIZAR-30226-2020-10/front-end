import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuneit/pages/login.dart';
import 'package:tuneit/pages/register.dart';

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
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      color: Colors.transparent,
                      child: boton('INICIAR SESIÓN')
                  )
              ),
              Container(
                color: Colors.transparent,
                height: 20,
              ),
              Flexible(
                  flex: 2,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    color: Colors.transparent,
                    child: boton('REGISTRARSE'),
                  )
              )
            ]
        )
    );
  }
}

SizedBox boton (String title) {
  return new SizedBox(
    height: 60,
    width: 230.0,
    child: Container(
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
              bottomLeft: const Radius.circular(25.0),
              bottomRight: const Radius.circular(25.0),
            ),
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xAA823b8e),
                Color(0xAA5350a7),
                Color(0xAA1c4c8b),
              ],
            ),
            border: Border.all(color: Colors.white, width: 4)
        ),
        child: Center(
          child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'RobotoMono'
              )
          ),
        )
    ),
  );
}