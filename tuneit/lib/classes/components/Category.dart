import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tuneit/classes/components/Audio.dart';

class Category {
  String name;
  String description;
  String image = 'https://i.blogs.es/6c558d/luna-400mpx/450_1000.jpg';

  Category({this.name,this.description});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
        name: parsedJson['name'],
        description: parsedJson['description'],
    );
  }

}

const baseURL = 'psoftware.herokuapp.com';

Future<List<Category>> listCategories () async{
  List<Category> list = List();

  var uri = Uri.https(baseURL,'/list_categories' , null);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  if (response.statusCode == 200) {
    list = (json.decode(response.body) as List)
        .map((data) => new Category(name: data, description: 'ey'))
        .toList();

    return list;
  }
  else {
    throw Exception('Failed to load categories');
  }
}
