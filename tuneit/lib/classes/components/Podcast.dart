import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'PodcastEpisode.dart';


class Podcast {
  String id;
  String name;
  String image;
  String description;
  String web_link;

  Podcast({this.id,this.name, this.image,this.description,this.web_link});
  // [ {“ID”:, “Nombre” : x, “Artistas”:[], ”Album”: ,”URL”: }, Id2{}, …]

  factory Podcast.fromJson(Map<String, dynamic> parsedJson) {

    return Podcast(
        id: parsedJson['id'],
        name: parsedJson['title'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        web_link: parsedJson['link'],
    );
  }

  factory Podcast.fromJson2(Map<String, dynamic> parsedJson) {

    return Podcast(
      id: parsedJson['id'],
      name: parsedJson['title_original'],
      image: parsedJson['image'],
      description: parsedJson['description_original'],
      web_link: parsedJson['website'],
    );
  }

}
const baseURL = 'listen-api.listennotes.com';
Future<List<Podcast>> fetchBestPodcasts() async {
  var uri = Uri.https(baseURL, '/api/v2/best_podcasts');
  final http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-ListenAPI-Key': 'fb46ce2b5ca54885969d1445995238e1'
    },
  );

  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);
    var list = parsedJson['podcasts'] as List;
    List<Podcast> podcastsList = list.map((i) =>Podcast.fromJson(i)).toList();

    return podcastsList;

  } else {
    throw Exception('Failed to load playlists');
  }
}

Future<List<Podcast>> fetchPodcastByTitle(String title) async {
  var queryParameters = {
    "q" : title,
    "type" : "podcast",
    "language" : "Spanish"
  };
  var uri = Uri.https(baseURL, "/api/v2/search", queryParameters);
  final http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-ListenAPI-Key': 'fb46ce2b5ca54885969d1445995238e1'
    },
  );

  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);
    var list = parsedJson['results'] as List;
    List<Podcast> podcastList = list.map((i) =>Podcast.fromJson2(i)).toList();

    return podcastList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load podcasts');
  }
}
