import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';

//------------------------------------------------------------------------------
InputDecoration textField2 (String text, IconData ic) {
  return InputDecoration(
    hintText: text,
    prefixIcon: Padding(
      padding: EdgeInsets.all(0.0),
      child: Icon(
        ic,
        color: ColorSets.colorGrey,
      ),
    ),
    hintStyle: TextStyle(
        fontSize: 15,
        color: Colors.white60,
        fontFamily: 'RobotoMono'
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: ColorSets.colorWhite),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: ColorSets.colorPurple),
    ),
  );
}

Widget textField(TextEditingController _controller, bool obscureText, String text, IconData ic) {
  return TextFormField(
    controller: _controller,
    obscureText: obscureText,
    style: TextStyle(
        color: ColorSets.colorText,
        fontFamily: 'RobotoMono'
    ),
    decoration: textField2(text, ic),
  );
}

//------------------------------------------------------------------------------