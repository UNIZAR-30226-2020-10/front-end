import 'dart:convert';

import 'dart:io';
import 'dart:async';

import 'package:encrypt/encrypt.dart' as Encrypter;
import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/notificaciones/Notificacion.dart';
import 'package:tuneit/classes/components/notificaciones/PushProvider.dart';
import 'package:tuneit/classes/values/Globals.dart';
import 'package:tuneit/classes/values/Constants.dart';


class User {
  final String name;
  final String email;
  final String password;
  final String date;
  final String country;
  final String photo;
  final String token;


  User({this.name, this.email, this.password, this.date, this.country,this.photo,this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    print('b');
    String fecha="";
    String pais="";
    String token="";
    if(json['Fecha']==null){
      fecha=Globals.date;
    }
    else{
    fecha=json['Fecha'];
    }

    if(json['Pais']==null){
      pais=Globals.country;
    }
    else{
      pais=json['Pais'];
    }
    if(json['Token']==null){
      token=Globals.mi_token;
    }
    else{
      token=json['Token'];
    }

    return User(
      name: json['Nombre'],
      email: json['Email'],
      password: json['Password'],
      date: fecha,
      country: pais,
      photo: json['Imagen'],
      token: token,
    );
  }

}

Future<List<User>> searchUsers(String nombre) async {
  List<User> list=[];

  var queryParameters = {
    'nombre' : nombre,
  };
  var uri = Uri.http(baseURL, '/search_users', queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if(response.statusCode==200){


    list = (json.decode(response.body) as List)
        .map((data) => new User.fromJson(data))
        .toList();


    print(list.length);
    if(list!=[]){
      print(list[0].name);
    }


  }
  else{
    print("No se han encontrado resultados para amigos");
    print(response.statusCode);

  }

  return list;


}


Future<bool> enviarSolicitud(
    String emisor,String receptor,String token
    ) async {

  final http.Response response = await http.post(
    'https://' + baseURL + '/solicitud_amistad',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'emisor': emisor,
      'receptor': receptor,
    }),
  );

  print(response.body);
  if (response.body == 'Success') {
    sendNotification('Solcitud de amistad',emisor+' quiere ser tu amigo',token);
    return true;
  } else {
    return false;
  }
}



Future<bool> registerUser(
    String name, String email, String password, String date, String country
    ) async {


  /*Aqui en el futuro habra que añadir esto*/
  var pus1=PushProvider();
  String token=pus1.devolverToken();

  //Meter el token en el json  <-----

  final http.Response response = await http.post(
    'https://' + baseURL + '/register',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'nombre': name,
      'email': email,
      'password': password,
      'fecha': date,
      'pais': country,
    }),
  );
  if (response.body == 'Success') {
    return true;
  } else {
    return false;
  }
}

Future<String> fetchUser(String email, String password) async {
  var queryParameters = {
    'email' : email,
    'password' : password,
  };
  var uri = Uri.http(baseURL, '/sign_in', queryParameters);
  final http.Response response = await http.get(uri);
  return response.body;
}

//final _cancionStreamController

Future<List<User>> listarAmigos() async{

  List<User> list=[];

  var queryParameters = {
    'email' : Globals.email,
  };
  var uri = Uri.http(baseURL, '/list_friends', queryParameters);
  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });
  if(response.statusCode==200){


    list = (json.decode(response.body) as List)
        .map((data) => new User.fromJson(data))
        .toList();

    print(response.body);
    print(list.length);

  }
  else{
    print("No se han encontrado resultados para amigos");
    print(response.statusCode);

  }
  return list;


}

Future<List<String>> infoUser(String email) async {
  var queryParameters = {
    'email' : email,
  };
  var uri = Uri.http(baseURL, '/info_usuario', queryParameters);
  final http.Response response = await http.get(uri);
  Map<String, dynamic> parsedJson = json.decode(response.body);

  if (response.body != 'Error' && response.body != 'No existe el usuario') {
    List<String> list = List(5);
    list [0] = parsedJson['Nombre'];
    list [1] = parsedJson['Password'];
    list [2] = parsedJson['fecha'];
    list [3] = parsedJson['Pais'];
    list [4] = parsedJson['Foto'];

    return list;
  } else {
    throw Exception(response.body + ': Failed to get info user');
  }
}

Future<bool> deleteUser(
    String email, String password
    ) async {

  final http.Response response = await http.post(
    'https://' + baseURL + '/delete_user',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (response.body == 'Success') {
    return true;
  } else {
    return false;
  }
}

Future<void> settingsUser(String password, String name, String pais)async{
  bool exito = false;
  var body;



  if(name!="" && Globals.name!=name){

    body = jsonEncode(<String, String>{
      'email': Globals.email,
      'password': Globals.password,
      'nombre': name,
    });

    exito=await upDateSettings(body);
    if(exito){
      Globals.name=name;
    }

  }
  if(pais!="" && Globals.country!=pais){
    body = jsonEncode(<String, String>{
      'email': Globals.email,
      'password': Globals.password,
      'pais': pais,
    });

    exito=await upDateSettings(body);
    if(exito){
      Globals.country=pais;
    }

  }

  if(password!="" && password!=Globals.password){
    final key = Encrypter.Key.fromUtf8('KarenSparckJonesProyectoSoftware');
    final iv = Encrypter.IV.fromLength(16);
    final encrypter = Encrypter.Encrypter(Encrypter.AES(key,mode: Encrypter.AESMode.ecb));
    final encrypted = encrypter.encrypt(password, iv: iv);
    password=encrypted.base64;
    print(password);

    body = jsonEncode(<String, String>{
      'email': Globals.email,
      'password': Globals.password,
      'new_password':password,
    });

    exito=await upDateSettings(body);
    if(exito){
      Globals.password=password;
    }

  }
  }


Future<bool> upDateSettings( body) async{
  print(body);

  final http.Response response = await http.post(
    'https://' + baseURL + '/modify',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: body,
  );
  print(response.body);
  if (response.body == 'Success') {
    return true;
  } else {
    return false;
  }

}

Future<void> startUploadPhoto( File tmpFile , String base64Image){
  if(null == tmpFile){
    print("error");
  }
  String fileName= tmpFile.path.split('/').last;

  http.post('vacio_porahora',body:{
    "image": base64Image,
    "name": fileName,
  });


}

