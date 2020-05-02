import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/Audio.dart';




class Song extends Audio{
  String name;
  String album;
  List<String> artist;
  String url;
  int id;
  final String image;

  @override
  String devolverSonido(){
    return url;

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
    return juntarArtistas(artist);
  }
  String devolverID(){
    return id.toString();
  }

  String devolverGenero(){
    return "";
  }


  String juntarArtistas(List<String> datos){
    String juntitos="";
    for(int i=0;i<datos.length;i++){
      juntitos+=datos[i] + ' ';

    }
    return juntitos;

  }

  Song({this.name,this.album, this.artist,this.url,this.id,this.image});


  factory Song.fromJson(Map<String, dynamic> parsedJson) {

    var streetsFromJson  = parsedJson['Artistas'];

    List<String> losartistas = streetsFromJson.cast<String>();

    return Song(
      id: parsedJson['ID'],
      name: parsedJson['Nombre'],
      album: parsedJson['Album'],
      artist: losartistas,
      url :parsedJson['URL'],
      image: parsedJson['Imagen']
    );
  }

}
const baseURL = 'psoftware.herokuapp.com';

class SongLista{

  final int id;
  final String name;
  final String description;
  final String image;
  final bool cancionesOEpisodios;
  List<Audio> songs= new List<Audio>();

  SongLista({this.id, this.name, this.description, this.image,this.songs, this.cancionesOEpisodios});

  factory SongLista.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['Canciones'] as List;
    List<Song> songsList = list.map((i) =>Song.fromJson(i)).toList();

    return SongLista(
      id: parsedJson['ID'],
      name: parsedJson['Nombre'],
      description: parsedJson['Desc'],
      image: parsedJson['Imagen'],
      songs: songsList
    );
  }
  Future< SongLista> fetchSonglists(String id) async {
    print(id);


    var queryParameters = {
      'lista' : id
    };
    var uri = Uri.https(baseURL,'/list_data' ,queryParameters);
    final http.Response response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      return SongLista.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load playlists');
    }
  }

}

Future<void> eliminarCancionDeLista(String id_lista, String id_song) async {
  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/delete_from_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'cancion': id_song,
      'lista': id_lista
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to delete a song');
  }

}

void agregarCancion( String  id_lista, String id_song) async{

  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/add_to_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'cancion': id_song,
      'lista': id_lista
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Failed to load album');
  }

}

Future< SongLista> fetchSonglists(String id) async {

  var queryParameters = {
    'lista' : id
  };
  var uri = Uri.https(baseURL,'/list_data' ,queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {

    return SongLista.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load playlists');
  }
}


Future<List<Song>> buscar_canciones(String contenido_busqueda) async {

  List<Song> list;
  var queryParameters = {
    'nombre' : contenido_busqueda
  };

  var uri = Uri.https(baseURL,'/search' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });


  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Song.fromJson(data))
        .toList();

    return list;

  } else {

    print('Failed to load playlists');
    return null;
  }
}
/*
    lista: id de la lista a modificar
    before: posición inicial de la cancion a mover
    after: posición final de la cancion a mover
*/
Future<bool> reposicionarCancion(String id_lista, String before,String after) async{
  bool exito= false;

  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/reorder',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'lista': id_lista,
      'before':before,
      'after':after
    }),
  );
  if (response.statusCode == 200) {

    exito=true;
  } else {

    print('Failed to reposition');
  }

  return exito;


}





