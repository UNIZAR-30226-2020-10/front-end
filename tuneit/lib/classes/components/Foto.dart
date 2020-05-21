
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';



Future <File> chooseImage_Gallery() async{

  return ImagePicker.pickImage(source: ImageSource.gallery);

  }


  Future <File> chooseImage_Camera() async{
    return ImagePicker.pickImage(source: ImageSource.camera);

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




