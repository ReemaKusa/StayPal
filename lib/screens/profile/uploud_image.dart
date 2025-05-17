import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker_=ImagePicker();
  XFile? _file= await imagePicker_.pickImage(source:source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  print('No Image Selected');//devices gallery
  // devices gallery or camera

}