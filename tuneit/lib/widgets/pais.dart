
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuneit/classes/values/ColorSets.dart';

Widget widget_paises(Widget f){
  return Row(
    children: <Widget>[
      Flexible(
        child: SizedBox(width: 12,),
      ),
      Flexible(
        child: Icon(
          Icons.place,
          color: ColorSets.colorGrey,
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
      value: 'Argentina',
      child: Text('Argentina'),
    ),
    DropdownMenuItem(
      value: 'Colombia',
      child: Text('Colombia'),
    ),
    DropdownMenuItem(
      value: 'Cuba',
      child: Text('Cuba'),
    ),
    DropdownMenuItem(
      value: 'España',
      child: Text('España'),
    ),
    DropdownMenuItem(
      value: 'Ecuador',
      child: Text('Ecuador'),
    ),
    DropdownMenuItem(
      value: 'Estados Unidos',
      child: Text('Estados Unidos'),
    ),
    DropdownMenuItem(
      value: 'Italia',
      child: Text('Italia'),
    ),
    DropdownMenuItem(
      value: 'Mexico',
      child: Text('Mexico'),
    ),
    DropdownMenuItem(
      value: 'Portugal',
      child: Text('Portugal'),
    ),
    DropdownMenuItem(
      value: 'Puerto Rico',
      child: Text('Puerto Rico'),
    ),
    DropdownMenuItem(
      value: 'Venezuela',
      child: Text('Venezuela'),
    ),

  ];
}