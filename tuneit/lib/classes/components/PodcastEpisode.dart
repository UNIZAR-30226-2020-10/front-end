import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/Audio.dart';


class PodcastEpisode extends Audio {
  String id;
  String name;
  String image;
  String description;
  String audio; //URL DEL ESPISODIO
  int audio_length_sec;
  String web_link;
  String publisher;

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
    return name;
  }

  @override
  String devolverArtista(){
    return publisher;
  }

  String devolverID(){
    return id;
  }

  PodcastEpisode({this.id,this.name, this.image,this.description,this.audio,this.audio_length_sec,this.web_link});

  factory PodcastEpisode.fromJson(Map<String, dynamic> parsedJson) {

    return PodcastEpisode(
        id: parsedJson['id'],
        name: parsedJson['title'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        audio :parsedJson['audio'],
        audio_length_sec: parsedJson['audio_length_sec'],
        web_link: parsedJson['link']
    );
  }

  void setPublisher (String pub) {
    publisher = pub;
  }

}

const baseURL = 'listen-api.listennotes.com';
Future<List<PodcastEpisode>> fetchEpisodes(String podc) async {
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
    List<PodcastEpisode> episodesList = list.map((i) => PodcastEpisode.fromJson(i)).toList();

    for(int i = 0; i < episodesList.length; i++) {
      episodesList[i].setPublisher(parsedJson['publisher'] as String);
    }

      return episodesList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load episodes');
  }
}

Future<List<PodcastEpisode>> fetchEpisodeByTitle(String title) async {
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
    List<PodcastEpisode> episodeList = list.map((i) =>PodcastEpisode.fromJson(i)).toList();

    return episodeList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load episodes');
  }
}

