import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
InputDecoration textField2 (String text, IconData ic) {
  return InputDecoration(
    hintText: text,
    prefixIcon: Padding(
      padding: EdgeInsets.all(0.0),
      child: Icon(
        ic,
        color: Colors.grey,
      ),
    ),
    hintStyle: TextStyle(
        fontSize: 15,
        color: Colors.white60,
        fontFamily: 'RobotoMono'
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF5350a7)),
    ),
  );
}

Widget textField(TextEditingController _controller, bool obscureText, String text, IconData ic) {
  return TextFormField(
    controller: _controller,
    obscureText: obscureText,
    style: TextStyle(
        color: Colors.white,
        fontFamily: 'RobotoMono'
    ),
    decoration: textField2(text, ic),
  );
}

//------------------------------------------------------------------------------