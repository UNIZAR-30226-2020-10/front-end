import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const baseURL = 'https://psoftware.herokuapp.com/list_lists';

class Playlist {
  final int id;
  final String name;
  final String description;
  final String image;

  Playlist({this.id, this.name, this.description, this.image});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['ID'],
      name: json['Nombre'],
      description: json['Desc'],
      image: json['Image'],
    );
  }

}


  Future<List<Playlist>> fetchPlaylists() async {
    List<Playlist> list = List();
    final response = await http.get(baseURL);
    if (response.statusCode == 200) {
      print(response.body);
      list = (json.decode(response.body) as List)
          .map((data) => new Playlist.fromJson(data))
          .toList();

      return list;
    } else {
      throw Exception('Failed to load playlists');
    }
  }
