
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tuneit/classes/values/Constants.dart';
import 'package:tuneit/classes/values/Globals.dart';



Future <File> chooseImage_Gallery() async{

  return ImagePicker.pickImage(source: ImageSource.gallery);

  }


  Future <File> chooseImage_Camera() async{
    return ImagePicker.pickImage(source: ImageSource.camera);

  }

/**Subir imágenes a amazon
    /sign_s3
    Da permiso para subir una imagen a GitHub

    Entrada
    file_type: tipo de archivo
    file_name: nombre de archivo
    Salida
    {"data": datos, "url": url de amazon}
 **/


Future<void> startUploadPhoto( File tmpFile , String base64Image) async{
  //tmpFile.
  //image/jpeg
  String fileName= tmpFile.path.split('/').last;
  print(fileName);

  var queryParameters = {
    'file_type:' : 'image/jpeg',
    'file_name' : fileName,
  };

  var uri = Uri.https(baseURL,'/sign_s3' ,queryParameters);
  print(uri);

  final http.Response response = await http.get(uri, headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
  });


  /*final http.Response responseAmazon = await http.post(
    'URL DE AMAZON',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'file': id_song,
      'lista': id_lista
    }),
  );

  if(responseAmazon.statusCode==200||responseAmazon.statusCode==204){
    //Actualizar imagen del usuario
    Globals.image;

  }*/


  print(response.body);

}




