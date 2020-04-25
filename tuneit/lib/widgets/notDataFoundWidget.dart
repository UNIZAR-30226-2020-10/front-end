import 'package:flutter/cupertino.dart';
import 'package:tuneit/classes/values/Constants.dart';

Widget NotDataFound(){
  return Center(
    child: ListView(
      children: <Widget>[
        Image(image: AssetImage(logoApp),
            fit: BoxFit.fill,
            width: 200,
            height: 200),
        Text(textoInutil_1)


      ],
    ),
  );
}