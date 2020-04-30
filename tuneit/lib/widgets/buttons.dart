import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';

//------------------------------------------------------------------------------
// Widget del botón con degradado de colores sin comportamiento (NO USAR)
SizedBox gradientButton2 (String title, double height, double width, double fontSize) {
  return new SizedBox(
    height: height, // 50
    width: width, // 230
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
                ColorSets.colorPink,
                ColorSets.colorButtonPurple,
                ColorSets.colorButtonBlue,
              ],
            ),
            border: Border.all(color: ColorSets.colorWhite, width: 2)
        ),
        child: Center(
          child: Text(
              title,
              style: TextStyle(
                  fontSize: fontSize, // 20
                  color: ColorSets.colorText,
                  fontFamily: 'RobotoMono'
              )
          ),
        )
    ),
  );
}

// Widget del botón con degradado de colores funcional
//  func: función que describe el comportamiento onPressed del botón
//  arguments: lista con los argumentos de func (EN ORDEN)
// Ejemplo en pages/mainView.dart
Widget gradientButton (BuildContext context, Function func, List arguments, String text, double height, double width, double fontSize) {
  return RaisedButton(
      onPressed: () {
        Function.apply(func, arguments);
      },
      color: Colors.transparent,
      elevation: 0.0,
      child: gradientButton2(text, height, width, fontSize)
  );
}

//------------------------------------------------------------------------------
// Widget del botón con color sólido funcional
//  func: función que describe el comportamiento onPressed del botón
//  arguments: lista con los argumentos de func (EN ORDEN)
// Ejemplo en pages/login.dart y pages/register.dart
Widget solidButton (BuildContext context, Function func, List arguments, String text, double height, double width, double fontSize) {
  return RaisedButton(
      onPressed: () {
        Function.apply(func, arguments);
      },
      color: Colors.transparent,
      elevation: 0.0,
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                  bottomLeft: const Radius.circular(25.0),
                  bottomRight: const Radius.circular(25.0),
                ),
                color: ColorSets.colorDarkGrey,
                border: Border.all(color: ColorSets.colorWhite, width: 2)
            ),
            child: Center(
              child: Text(
                  text,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: ColorSets.colorText,
                      fontFamily: 'RobotoMono'
                  )
              ),
            )
        ),
      )
  );
}

//------------------------------------------------------------------------------
Widget simpleButton (BuildContext context, Function func, List arguments, String text) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
          bottomLeft: const Radius.circular(15.0),
          bottomRight: const Radius.circular(15.0),
        ),
        color: ColorSets.colorDarkGrey,
    ),
    child:  FlatButton(
      child: Text(text),
      onPressed: () {
        Function.apply(func, arguments);
      },
    ),
  );
}

//------------------------------------------------------------------------------
Widget criticalButton (BuildContext context, Function func, List arguments, String text, double height, double width, double fontSize) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      borderRadius: new BorderRadius.only(
        topLeft: const Radius.circular(15.0),
        topRight: const Radius.circular(15.0),
        bottomLeft: const Radius.circular(15.0),
        bottomRight: const Radius.circular(15.0),
      ),
      border: Border.all(color: ColorSets.colorCritical, width: 2),
    ),
    child:  FlatButton(
      child: Text(text, style: TextStyle(fontSize: fontSize, color: ColorSets.colorCritical),),
      onPressed: () {
        Function.apply(func, arguments);
      },
    ),
  );
}