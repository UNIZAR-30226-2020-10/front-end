import 'package:flutter/material.dart';

class Playlist {
  String titulo_lista;
  String url_imagen;

  Playlist({this.titulo_lista, this.url_imagen});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      titulo_lista: json['titulo_lista'],
      url_imagen: json['url_imagen'],
    );
  }
}
