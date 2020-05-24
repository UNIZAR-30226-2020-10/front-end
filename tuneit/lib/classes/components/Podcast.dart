import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/User.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';


class Podcast {
  String id="";
  String name="";
  String image="";
  String description="";
  String web_link="";

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
      'X-ListenAPI-Key': Globals.api_key_podc
    },
  );

  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);
    var list = parsedJson['podcasts'] as List;
    List<Podcast> podcastsList = list.map((i) =>Podcast.fromJson(i)).toList();

    return podcastsList;

  } else {
    throw Exception('Failed to load podcasts lists');
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
      'X-ListenAPI-Key': Globals.api_key_podc
    },
  );

  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);
    var list = parsedJson['results'] as List;
    List<Podcast> podcastList = list.map((i) =>Podcast.fromJson2(i)).toList();

    return podcastList;

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load podcasts 2');
  }
}

Future<Podcast> fetchPodcast(String podc) async {
  var uri = Uri.https(baseURL_POD, '/api/v2/podcasts/${podc}');
  final http.Response response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'X-ListenAPI-Key': Globals.api_key_podc
    },
  );
  if (response.statusCode == 200) {

    Map<String, dynamic> parsedJson = json.decode(response.body);

    return Podcast.fromJson3(parsedJson);

  } else {
    throw Exception(response.statusCode.toString() + ': Failed to load podcasts 1');
  }
}

Future<List<Podcast>> fetchPodcastById(List<String> ids) async {
  List<Podcast> list = List();
  for (String i in ids) {
    Podcast podc = await fetchPodcast(i);
    list.add(podc);
  }

  return list;
}


Future<List<Podcast>> fetchFavPodcasts() async {
  var queryParameters = {
    'email' : Globals.email,
  };
  var uri = Uri.http(baseURL, '/list_podcast', queryParameters);
  final http.Response response = await http.get(uri,headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad,
  });

  if (response.statusCode == 200) {
    List<String> list = (json.decode(response.body) as List)
        .map((data) => data.toString())
        .toList();

    List<Podcast> podcastList = await fetchPodcastById(list);

    return podcastList;
  }
  else {
    throw Exception(response.body + ': Failed to check favourite podcast');
  }
}

Future<void> isFav(String id, String name) async {

  final http.Response response = await http.post(
    'https://' + baseURL + '/podcast_fav',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader:Globals.seguridad,
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
      HttpHeaders.authorizationHeader:Globals.seguridad,
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
  final http.Response response = await http.get(uri,headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad,
  });

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


/****
 * Compartir podcast
    /share_podcast
    Comparte un podcast a un usuario

    Entrada
    podcast: id de la lista a compartir
    emisor: emisor de la cancion
    receptor: receptor de la cancion
    Salida
    "Mismo usuario": no se puede enviar cosas a sí mismo
    "Elemento ya compartido con ese usuario": ya se ha compartido antes
    "Error"
    "Success"
 *****************/
Future<bool>  compartirPodcast(String podcast, String receptor) async {

  var queryParameters = {
    'podcast':podcast,
    'emisor' : Globals.email,
    'receptor':receptor
  };

  var uri = Uri.https(baseURL,'/share_podcast' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad,
  });

  if (response.statusCode == 200 && response.body== 'Success' ) {

    String token= await getToken(receptor);
    sendNotification('Recomendación',Globals.name +' te ha recomendado un podcast',token);

    return true;

  } else {

    print('Error al compartir podcast');
    return false;
  }
}

//dejarDeCompartirPodcast(listas[index].podcast);
Future<bool>  dejarDeCompartirPodcast(String id_compartida) async {

  var queryParameters = {
    'podcast':id_compartida
  };

  var uri = Uri.https(baseURL,'/unshare_podcast' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });

  if (response.statusCode == 200 && response.body== 'Success' ) {

    return true;

  } else {

    print('Error al dejar de compartir la lista de reproducción');
    return false;
  }
}




