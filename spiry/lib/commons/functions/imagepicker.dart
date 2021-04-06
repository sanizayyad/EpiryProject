

import 'dart:io';
import 'package:spiry/locator.dart';
import 'package:spiry/services/navigation/navigationservice.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> imagePicker(context) async{
  ImageSource _imageSource;
  Future<bool> imageSourceDialog(context){
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Center(child: Text("Select image source")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                      onPressed: () async{
                        locator<NavigationService>().pop(true);
                        _imageSource =ImageSource.camera;
                      },
                      child: Text("Camera",style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),)),
                  FlatButton(
                      onPressed: ()async{
                        locator<NavigationService>().pop(true);
                        _imageSource =ImageSource.gallery;
                      },
                      child: Text("Gallery",style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),))
                ],
              ),
            )
    );
  }
  await imageSourceDialog(context);
  try {
    File image =  await ImagePicker.pickImage(source: _imageSource,imageQuality: 50);
    return image;
  } catch (e) {
  }
  return null;
}
