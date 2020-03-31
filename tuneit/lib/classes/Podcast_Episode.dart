import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Podcast_Episode{
  String id;
  String title;
  String image;
  String description;
  String audio;
  int audio_length_sec;
  String web_link;

  Podcast_Episode({this.id,this.title, this.image,this.description,this.audio,this.audio_length_sec,this.web_link});

  factory Podcast_Episode.fromJson(Map<String, dynamic> parsedJson) {

    var podcastsFromJson  = parsedJson['Podcast'];
    //print(streetsFromJson.runtimeType);
    // List<String> streetsList = new List<String>.from(streetsFromJson);
    List<String> podcasts = podcastsFromJson.cast<String>();

    return Podcast_Episode(
        id: parsedJson['ID'],
        title: parsedJson['Nombre'],
        image: parsedJson['image'],
        description: parsedJson['descriptio'],
        audio :parsedJson['audio'],
        audio_length_sec: parsedJson['audio_length_sec'],
        web_link: parsedJson['web_link']
    );
  }

}
