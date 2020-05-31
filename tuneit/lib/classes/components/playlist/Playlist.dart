import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/usuario/User.dart';
import 'package:tuneit/classes/components/notificaciones/CompartidaLista.dart';
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/classes/values/Constants.dart';



class Playlist {
  final int id;
  final String name;
  final String description;
  final String image;

  Playlist({this.id, this.name, this.description, this.image});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['ID'],
      name: json['Nombre'],
      description: json['Desc'],
      image: json['Imagen'],
    );
  }

}


  Future<List<Playlist>> fetchPlaylists(String user) async {
  List<Playlist> list = List();

  var queryParameters = {
    'email' : user
  };

  var uri = Uri.https('psoftware.herokuapp.com','/list_lists' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });




  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();

    return list;
  } else {
    throw Exception('Failed to load playlists');
  }
}


Future<List<Playlist>> buscar_una_lista(String data, String user) async {

  List<Playlist> list = List();

  var queryParameters = {
    'lista' : data,
    'email':user
  };
  ///search_list

  var uri = Uri.https('psoftware.herokuapp.com','/search_list' ,queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });

  if (response.statusCode == 200) {

    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();
    return list;

  } else {
    print('Failed to load playlists');
    return null;
  }
}

Future<void> nuevaLista(String nombre, String desc, String email) async {

  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/create_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader:Globals.seguridad
    },


    body: jsonEncode(<String, String>{
      'lista': nombre,
      'desc': desc,
      'email':email
    }),
  );

  if (response.statusCode == 200) {

  } else {

    throw Exception('Failed to create a new list');
  }

}

Future<void> borrarLista(String id) async {

  final http.Response response = await http.post(
    'https://psoftware.herokuapp.com/delete_list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader:Globals.seguridad
    },


    body: jsonEncode(<String, String>{
      'lista': id,
    }),
  );

  if (response.statusCode == 200) {

  } else {

    throw Exception('Failed to create a new list');
  }

}

Future<List<Playlist>> listasUsuario(String email) async {

  List<Playlist> list = List();

  var queryParameters = {
    'email' : email,
  };

  var uri = Uri.https(baseURL,'/list_lists', queryParameters);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });

  if (response.statusCode == 200) {

    list = (json.decode(response.body) as List)
        .map((data) => new Playlist.fromJson(data))
        .toList();
    return list;

  } else {
    print('Failed to load user playlists');
    return null;
  }
}


//***Compartir lista
///share_list
//Comparte una lista de reproducción a un usuario
//
//    Entrada
//        lista: id de la lista a compartir
//        emisor: emisor de la cancion
//        receptor: receptor de la cancion
//    Salida
//        "Mismo usuario": no se puede enviar cosas a sí mismo
//        "Elemento ya compartido con ese usuario": ya se ha compartido antes
//        "Error"
//        "Success"**/
Future<bool>  compartirLista(String amigo, String id_lista, String receptor, String emisor) async {

  var queryParameters = {
    'lista':id_lista,
    'emisor' : Globals.email,
    'receptor':amigo
  };

  var uri = Uri.https(baseURL,'/share_list' ,queryParameters);


  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });

  if (response.statusCode == 200 && response.body== 'Success' ) {

    String token= await getToken(receptor);
    sendNotification('Recomendación',emisor+' te ha recomendado una lista de reproducción',token);

    return true;

  } else {

    print('Error al compartir la lista de reproducción');
    return false;
  }
}
/**************Dejar de compartir lista
    /unshare_list
    Elimina la compartición de una lista de reproducción

    Entrada
    lista: id de la lista_compartida, no id de lista de reproduccion
    Salida
    "No existe": no existe la compartición a eliminar
    "Error"
    "Success"
 *******************/

Future<bool>  dejarDeCompartirLista(String id_compartida) async {

  var queryParameters = {
    'lista':id_compartida
  };

  var uri = Uri.https(baseURL,'/unshare_list' ,queryParameters);

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


/****Añadir lista compartida a propias
/add_list
Añade una copia de una lista de reproducción ajena a la lista de listas de reproducción de un usuario

Entrada
lista: id de la lista a copiar
email: email del usuario que recibe la lista
Salida
"No existe usuario"
"No existe lista"
"Success"
"Error"
*********/


Future<bool>  agregarLista(String id_lista) async {

  var queryParameters = {
    'lista':id_lista,
    'email': Globals.email
  };

  var uri = Uri.https(baseURL,'/add_list' ,queryParameters);


  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });


  if (response.statusCode == 200 && response.body== 'Success' ) {

    return true;

  } else {

    print('Error al agregar la lista de reproducción');
    return false;
  }
}



/***listar_listas_compartidas_conmigo
    /list_listas_compartidas_conmigo
    Devuelve una lista con las listas compartidas a un usuario

    Entrada:
    email: email del usuario cuya información se muestra
    Salida:
    [{"ID": , "Emisor": (info_usuario), "Receptor": (info_usuario), "Lista": (list_lists_data : sin canciones), "Notificacion": }, {…}]
    “Error”
    "No existe usuario"
 *********/

Future<List<CompartidaLista>>  listasCompartidas() async {
  List<CompartidaLista> list=[];

  var queryParameters = {
    'email': Globals.email
  };

  var uri = Uri.https(baseURL,'/list_listas_compartidas_conmigo' ,queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader:Globals.seguridad
  });
  list = (json.decode(response.body) as List)
      .map((data) => new CompartidaLista.fromJson(data))
      .toList();


  if (response.statusCode == 200) {

    return list;

  } else {
    print(response.body);
    print(response.statusCode);
    print('Error al agregar la lista de reproducción');
    return list;
  }

}