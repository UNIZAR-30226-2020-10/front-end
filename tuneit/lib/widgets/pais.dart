
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
      value: 'Chile',
      child: Text('Chile'),
    ),
    DropdownMenuItem(
      value: 'Colombia',
      child: Text('Colombia'),
    ),
    DropdownMenuItem(
      value: 'Costa Rica',
      child: Text('Costa Rica'),
    ),
    DropdownMenuItem(
      value: 'Cuba',
      child: Text('Cuba'),
    ),
    DropdownMenuItem(
      value: 'Ecuador',
      child: Text('Ecuador'),
    ),
    DropdownMenuItem(
      value: 'España',
      child: Text('España'),
    ),
    DropdownMenuItem(
      value: 'Estados Unidos',
      child: Text('Estados Unidos'),
    ),
    DropdownMenuItem(
      value: 'Honduras',
      child: Text('Honduras'),
    ),
    DropdownMenuItem(
      value: 'Mexico',
      child: Text('Mexico'),
    ),
    DropdownMenuItem(
      value: 'Panamá',
      child: Text('Panamá'),
    ),
    DropdownMenuItem(
      value: 'Paraguay',
      child: Text('Paraguay'),
    ),
    DropdownMenuItem(
      value: 'Puerto Rico',
      child: Text('Puerto Rico'),
    ),
    DropdownMenuItem(
      value: 'Uruguay',
      child: Text('Uruguay'),
    ),
    DropdownMenuItem(
      value: 'Venezuela',
      child: Text('Venezuela'),
    ),

  ];
}