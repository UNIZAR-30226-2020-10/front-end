
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:dio/dio.dart' as dio;

import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:tuneit/classes/values/Globals.dart';



Future <File> chooseImage_Gallery() async{

  return ImagePicker.pickImage(source: ImageSource.gallery);

  }

  Future <File> chooseImage_Camera() async{
    return ImagePicker.pickImage(source: ImageSource.camera);

  }


Future<void> startUploadPhoto( File tmpFile , String base64Image) async{


  var dd= Dio();
  final file =tmpFile;
  final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
  final length = await file.length();

  final multipartFile = dio.MultipartFile(stream, length,
      filename: path.basename(file.path));


  var queryParameters = {
    'file_type:' :multipartFile.contentType.toString(),
    'file_name' : multipartFile.filename,
  };

  var uri = Uri.https(baseURL,'/sign_s3' ,queryParameters);


  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  print(response.body);
  Map<String, dynamic> parsedJson = json.decode(response.body);
  Map amazon=parsedJson["data"];
  Map fields=parsedJson["data"]["fields"];
  var url =amazon["url"];
  var url2= parsedJson["url"];


  var formData =  new FormData.fromMap(fields);
  formData.files.add(MapEntry('file',multipartFile));

  try{
    final Response responseA = await dd.post(url, data: formData);
  }
  on DioError catch (e) {

  print(e.response.statusCode);
  print(e.message);
  print(e.response.data);

}

Globals.image=parsedJson["url"];

}




