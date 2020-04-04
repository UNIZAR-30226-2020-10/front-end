import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuneit/classes/Audio.dart';


class Podcast_Episode extends Audio {
  String id;
  String title;
  String image;
  String description;
  String audio; //URL DEL ESPISODIO
  int audio_length_sec;
  String web_link;

  @override
  String devolverSonido(){
    return audio;
  }

  @override
  String devolverImagen(){
    return image;
  }

  @override
  String devolverTitulo(){
    return title;
  }

  @override
  String devolverArtista(){
    return "Autor";
  }



  Podcast_Episode({this.id,this.title, this.image,this.description,this.audio,this.audio_length_sec,this.web_link});

  factory Podcast_Episode.fromJson(Map<String, dynamic> parsedJson) {

    return Podcast_Episode(
        id: parsedJson['id'],
        title: parsedJson['title'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        audio :parsedJson['audio'],
        audio_length_sec: parsedJson['audio_length_sec'],
        web_link: parsedJson['link']
    );
  }

}

const baseURL = 'listen-api.listennotes.com';
Future<List<Podcast_Episode>> fetchEpisodes(String podc) async {
  var uri = Uri.https(baseURL, '/api/v2/podcasts/${podc}');
  final http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-ListenAPI-Key': 'fb46ce2b5ca54885969d1445995238e1'
    },
  );

  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);
    var list = parsedJson['episodes'] as List;
    List<Podcast_Episode> episodesList = list.map((i) =>Podcast_Episode.fromJson(i)).toList();

    return episodesList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load episodes');
  }
}

Future<List<Podcast_Episode>> fetchEpisodeByTitle(String title) async {
  var queryParameters = {
    "q" : title,
    "type" : "episode",
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
    List<Podcast_Episode> episodeList = list.map((i) =>Podcast_Episode.fromJson(i)).toList();

    return episodeList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load episodes');
  }
}

