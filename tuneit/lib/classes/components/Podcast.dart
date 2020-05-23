import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';


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

  factory Podcast.fromJson3(Map<String, dynamic> parsedJson) {

    return Podcast(
      id: parsedJson['id'],
      name: parsedJson['title'],
      image: parsedJson['image'],
      description: parsedJson['description'],
      web_link: parsedJson['website'],
    );
  }

}



Future<List<Podcast>> fetchBestPodcasts() async {
  var uri = Uri.https(baseURL_POD, '/api/v2/best_podcasts');
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
    throw Exception('Failed to load podcasts lists');
    return [];
  }
}

Future<List<Podcast>> fetchPodcastByTitle(String title) async {
  var queryParameters = {
    "q" : title,
    "type" : "podcast",
    "language" : "Spanish"
  };
  var uri = Uri.https(baseURL_POD, "/api/v2/search", queryParameters);
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
    throw Exception(response.statusCode.toString() + ': Failed to load podcasts 2');
    return [];
  }
}

Future<List<Podcast>> fetchPodcastById(String ids) async {
  Map map = {
    'ids': ids,
  };
  final http.Response response = await http.post(
    'https://' + baseURL_POD + '/api/v2/podcasts',
    headers: <String, String>{
      'X-ListenAPI-Key': 'fb46ce2b5ca54885969d1445995238e1',
    },
    body: map,
  );

  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);
    var list = parsedJson['podcasts'] as List;
    List<Podcast> podcastList = list.map((i) => new Podcast.fromJson3(i)).toList();

    return podcastList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load podcasts 1');
    return [];
  }
}


Future<List<Podcast>> fetchFavPodcasts() async {
  var queryParameters = {
    'email' : Globals.email,
  };
  var uri = Uri.http(baseURL, '/list_podcast', queryParameters);
  final http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    List<String> list = (json.decode(response.body) as List)
        .map((data) => data.toString())
        .toList();
    String ids = list.join(',');
    List<Podcast> podcastList = await fetchPodcastById(ids);

    return podcastList;
  }
  else {
    throw Exception(response.body + ': Failed to check favourite podcast');
    return [];
  }
}

Future<void> isFav(String id, String name) async {

  final http.Response response = await http.post(
    'https://' + baseURL + '/podcast_fav',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nombre' : name,
      'podcast' : id,
      'email' : Globals.email,
    }),
  );

  if (response.body != 'Success') {
    throw Exception(response.body + ': Failed to set favourite podcast');
  }
}

Future<void> isNotFav(String id) async {
  final http.Response response = await http.post(
    'https://' + baseURL + '/delete_podcast_fav',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'podcast' : id,
      'email' : Globals.email,
    }),
  );

  if (response.body != 'Success') {
    throw Exception(response.body + ': Failed to set not favourite podcast');
  }
}

Future<bool> checkFav(String id) async {
  var queryParameters = {
    'podcast' : id,
    'email' : Globals.email,
  };
  var uri = Uri.http(baseURL, '/podcast_is_fav', queryParameters);
  final http.Response response = await http.get(uri);

  if (response.body == 'True') {
    return true;
  }
  else if (response.body == 'False') {
    return false;
  }
  else {
    throw Exception(response.body + ': Failed to check favourite podcast');
  }
}
