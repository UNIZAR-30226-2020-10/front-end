import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseURL = 'https://jsonplaceholder.typicode.com';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String image;

  Playlist({this.id, this.name, this.description, this.image});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }

  /*Map toJson() {
    return {'id': id, 'name': name, 'description': description, 'image': image};
  }*/
}

Future<List<Playlist>> fetchPlaylists() async {
  List<Playlist> list = List();
  final response = await http.get(baseURL + '/list_lists');
  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();
    return list;
  } else {
    throw Exception('Failed to load playlists');
  }
}

