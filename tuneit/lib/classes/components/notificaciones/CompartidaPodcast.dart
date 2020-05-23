
import 'package:tuneit/classes/components/Song.dart';
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';

class CompartidaPodcast extends Notificacion{

  int id;
  String emisor_nombre;
  User emisor;
  User receptor;
  Song cancion;
  bool Notificacion;
  String photo_emisor=Globals.default_image;
  CompartidaPodcast({this.emisor_nombre,this.cancion,this.emisor,this.receptor,this. photo_emisor,this.id,this.Notificacion});


  String devolverEmisor(){
    return emisor_nombre;

  }

  int devolverID(){
    return id;
  }

  String devolverMensaje(){
    String des="Quiere ser tu amigo: ";
    des+=emisor_nombre;
    return des;

  }

  String devolverImagen(){
    return photo_emisor;
  }

  factory CompartidaPodcast.fromJson(Map<String, dynamic> json) {
    List<dynamic> prueba1=json['Emisor'];
    Map emisormap=prueba1[0];
    User emisor=new User.fromJson(json['Emisor'][0]);
    User receptor=new User.fromJson(json['Receptor'][0]);
    Song song=new Song.fromJson(json['Cancion']);
    return CompartidaPodcast(
      emisor:emisor,
      receptor: receptor,
      cancion:song,
      id:json['ID'],
      Notificacion: json['Notificacion'],
    );
  }

}