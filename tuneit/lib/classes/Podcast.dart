import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Podcast_Episode.dart';


class Podcast{
  String id;
  String title;
  String image;
  String description;
  String web_link;
  int total_episodes;
  List<Podcast_Episode> episodes;

  Podcast({this.id,this.title, this.image,this.description,this.web_link,this.total_episodes,this.episodes});
  // [ {“ID”:, “Nombre” : x, “Artistas”:[], ”Album”: ,”URL”: }, Id2{}, …]

  factory Podcast.fromJson(Map<String, dynamic> parsedJson) {

    var episodesFromJson  = parsedJson['episodes'];
    List<Podcast_Episode> _episodes = null; //episodesFromJson.cast<Podcast_Episode>();

    return Podcast(
        id: parsedJson['id'],
        title: parsedJson['title'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        web_link: parsedJson['web_link'],
        total_episodes: parsedJson['total_episodes'],
        episodes: _episodes
    );
  }

}

// https://
const baseURL = 'https://listen-api.listennotes.com/api/v2';
Future<List<Podcast>> fetchBestPodcasts() async {

  final http.Response response = await http.get(
    baseURL + '/best_podcasts',
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

