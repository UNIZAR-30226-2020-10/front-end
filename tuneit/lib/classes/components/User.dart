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
    baseURL + '/register',
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
    print('He entrado');
    return true;
  } else {
    return false;
  }
}
