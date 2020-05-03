
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget widget_paises(Widget f){
  return Row(
    children: <Widget>[
      Flexible(
        child: SizedBox(width: 12,),
      ),
      Flexible(
        child: Icon(
          Icons.place,
          color: Colors.grey,
          size: 25,
        ),
      ),
      Flexible(
        child: SizedBox(width: 15),
      ),
      Flexible(
        flex: 8,
        child:  f,
      )
    ],
  );
}




List< DropdownMenuItem<String>> Paises(){
  return[
    DropdownMenuItem(
      value: 'España',
      child: Text('España'),
    ),
    DropdownMenuItem(
      value: 'Italia',
      child: Text('Italia'),
    ),
    DropdownMenuItem(
      value: 'Portugal',
      child: Text('Portugal'),
    ),
    DropdownMenuItem(
      value: 'Portugal',
      child: Text('Portugal'),
    ),
    DropdownMenuItem(
      value: 'Colombia',
      child: Text('Colombia'),
    ),
    DropdownMenuItem(
      value: 'Argentina',
      child: Text('Argentina'),
    )
  ];
}