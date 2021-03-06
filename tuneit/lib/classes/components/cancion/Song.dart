import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/audio/Audio.dart';
import 'package:tuneit/classes/components/usuario/User.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';




class Song extends Audio{
  String name;
  String album;
  List<String> artist;
  String url;
  int id;
  List<String> genero;
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
    String lista = "";
    for(int i = 0; i < genero.length;i++){
      lista = lista + genero[i].toString() + " ";
    }
    return lista;
  }


  String juntarArtistas(List<String> datos){
    String juntitos="";
    for(int i=0;i<datos.length;i++){
      juntitos+=datos[i] + ' ';

    }
    return juntitos;

  }

  Song({this.name,this.album, this.artist,this.url,this.id,this.image,this.genero});


  factory Song.fromJson(Map<String, dynamic> parsedJson) {

    var streetsFromJson  = parsedJson['Artistas'];
    var genreFromJson = parsedJson['Categorias'];

    List<String> losartistas = streetsFromJson.cast<String>();
    List<String> losgeneros = genreFromJson.cast<String>();

    return Song(
      id: parsedJson['ID'],
      name: parsedJson['Nombre'],
      album: parsedJson['Album'],
      artist: losartistas,
      url :parsedJson['URL'],
      image: parsedJson['Imagen'],
      genero: losgeneros
    );
  }

}


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

}

Future<void> eliminarCancionDeLista(String id_lista, String id_song) async {
  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/delete_from_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader:Globals.seguridad
    },
    body: jsonEncode(<String, String>{
      'cancion': id_song,
      'lista': id_lista
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
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
      HttpHeaders.authorizationHeader:Globals.seguridad
    },
    body: jsonEncode(<String, String>{
      'cancion': id_song,
      'lista': id_lista
    }),
  );
  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to load album');
  }

}


Future< SongLista> fetchSonglists(String id) async {

  var queryParameters = {
    'lista' : id
  };
  var uri = Uri.https(baseURL,'/list_lists_data' ,queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
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
    HttpHeaders.authorizationHeader:Globals.seguridad
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
      HttpHeaders.authorizationHeader:Globals.seguridad
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

Future<List<Song>> lastAddedSongs() async {

  List<Song> list;

  var uri = Uri.https(baseURL,'/list' , null);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });


  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Song.fromJson(data))
        .toList();

    return list;

  } else {
    throw Exception(response.body + ': Failed to load last added songs');
  }
}

Future<List<Song>> songsByCategory(List<String> categories) async {

  List<Song> list = List();

  final http.Response response = await http.post(
    'https://' + baseURL + '/filter_category',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader:Globals.seguridad
    },
    body: jsonEncode(<String, dynamic>{
      'categorias' : categories
    }),
  );

  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Song.fromJson(data))
        .toList();

    return list;

  } else {
    throw Exception(response.body + ': Failed to load last added songs');
  }
}

/*Compartir cancion /share_song
Comparte una cancion a un usuario

    Entrada
        cancion: id de la cancion a compartir
        emisor: emisor de la cancion
        receptor: receptor de la cancion
    Salida
        "Mismo usuario": no se puede enviar cosas a sí mismo
        "Elemento ya compartido con ese usuario": ya se ha compartido antes
        "Error"
        "Success"
*/

Future<bool>  compartirCancion(String amigo, String id_song, String receptor, String emisor) async {

  var queryParameters = {
    'cancion':id_song,
    'emisor' : Globals.email,
    'receptor':amigo
  };

  var uri = Uri.https(baseURL,'/share_song' ,queryParameters);

  final http.Response response = await http.get(uri,headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad,
  });

      if (response.statusCode == 200 && response.body== 'Success' ) {

        String token= await getToken(receptor);
        sendNotification('Recomendación',emisor+' te ha recomendado una canción',token);

    return true;

  } else {

    print('Error al compartir la canción');
    return false;
  }
}


