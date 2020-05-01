
import 'dart:io';
import 'dart:async';

import 'package:image_picker/image_picker.dart';



Future <File> chooseImage_Gallery() async{

  return ImagePicker.pickImage(source: ImageSource.gallery);

  }


  Future <File> chooseImage_Camera() async{
    return ImagePicker.pickImage(source: ImageSource.camera);

  }





