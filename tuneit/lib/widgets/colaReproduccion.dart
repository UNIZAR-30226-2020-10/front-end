import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/values/ColorSets.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:getflutter/getflutter.dart';

Widget colaReproduccion(List<Song> canciones,int actual) {
  return new ListView.builder
    (
      itemCount: canciones.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return                                  Card(
          key: Key('$index'),
          child: new ListTile(

            leading:avatarImagen(canciones[index].image,actual,index),
            title: Text(canciones[index].name),
            subtitle: Text(canciones[index].devolverArtista()),
            trailing: PopupMenuButton<String>(
            /*onSelected: choiceAction,
              itemBuilder: (BuildContext context){
              return optionMenuSong.map((String choice){
              return PopupMenuItem<String>(
              value: (choice + "--"+songs.songs[index].id.toString()+"--"+indetificadorLista),
                child: Text(choice),
              );

            }).toList();*/
            //},
          ),

          ),
        );
      }
  );
}

Widget avatarImagen(String imagen,int actual,int indice){
  if(actual==indice){
    return GFAvatar(
      backgroundImage:NetworkImage(imagen),
      shape: GFAvatarShape.standard,
      backgroundColor: Colors.transparent,
    );
  }
  else{

    return GFAvatar(
      backgroundImage:AssetImage(imagenReproduciendo),
      shape: GFAvatarShape.standard,
      backgroundColor: Colors.transparent,
    );

  }


}
