import 'dart:convert';

import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/values/Globals.dart';


class User {
  final String name;
  final String email;
  final String password;
  final String date;
  final String country;


  User({this.name, this.email, this.password, this.date, this.country});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['nombre'],
      email: json['email'],
      password: json['password'],
      date: json['fecha'],
      country: json['pais'],
    );
  }

}


const baseURL = 'psoftware.herokuapp.com';

Future<bool> registerUser(
    String name, String email, String password, String date, String country
    ) async {

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

Future<bool> fetchUser(String email, String password) async {
  var queryParameters = {
    'email' : email,
    'password' : password,
  };
  var uri = Uri.http(baseURL, '/sign_in', queryParameters);
  final http.Response response = await http.get(uri);
  if (response.body == 'Success') {
    return true;
  } else {
    return false;
  }
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

Future<bool> settingsUser(String password, String name, String email)async{
  bool exito = false;
  if(password != "" || name != "") {
    var body;
    if (password != "" && name != "") {
       body = jsonEncode(<String, String>{
        'email': Globals.email,
        'password': password,
        'nombre': name,
      });
    }
    else if (password != "") {
     body = jsonEncode(<String, String>{
        'email': Globals.email,
        'password': password,
      });
    }
    else if (name != "") {
      body = jsonEncode(<String, String>{
        'email': Globals.email,
        'nombre': name,
      });
    }

    exito=await upDateSettings(body);
    if(exito){
      if(name!=""){Globals.name =name;}
      if(password!=""){Globals.password=password;}
    }
  }
    else{
      return exito;

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

