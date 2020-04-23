import 'dart:convert';

import 'package:http/http.dart' as http;


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
    throw Exception(response.body + ': Failed on register');
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
