import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spiry/commons/functions/imagepicker.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class ProductAddEditProvider extends BaseProviderModel{
  String error = "";
  File image;
  bool isDisposing;

  Future<void> saveProduct(formKey, productExist, ProductModel productModel) async {
    try {
      if (formKey.currentState.validate()) {
        isDisposing = false;
        setViewState(ViewState.Busy);
        if(image != null){
          String imageUrl = await fireStoreService.uploadFile(image, productModel.barcode);
          productModel.imageUrl = imageUrl;
        }
       if(!productExist)
         await fireStoreService.addProduct(productModel);
       else
         await fireStoreService.updateProduct(productModel);
        if (!isDisposing) {
          setViewState(ViewState.Success);
          await Future.delayed(Duration(milliseconds: 700));
          navigationService.pop(true);
        }
      }
    } catch (e) {
      print(e.message);
      error = e.message;
      setViewState(ViewState.Idle);
    }
  }
  Future<bool> deleteDialog(context, productModel, pop) {
    String message = pop ? "Are you sure you want to delete this product ?"
        : "Are you sure you want to delete ${productModel.length} product(s)?";
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    navigationService.pop(true);
                    if(pop)
                      delete(productModel, pop);
                    else
                      deleteAll(productModel);
                  },
                  child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: () {
                    navigationService.pop(false);
                  },
                  child: Text('No'),
                ),
              ],
            )
    );
  }
  Future delete(productModel, pop) async {
    setViewState(ViewState.Busy);
    try {
      await fireStoreService.removeProduct(productModel);
      setViewState(ViewState.Success);
      if (pop)
        navigationService.pop(true);
    } catch (e) {
      print(e.message);
      error = e.message;
    }
    setViewState(ViewState.Idle);
  }

  Future deleteAll(products) async{
    for(var prod in products){
      await delete(prod, false);
    }
  }

  Future pickImage(context) async{
    image = await imagePicker(context);
    if(image != null){
      setViewState(ViewState.Idle);
    }
  }

  void dispose(){
    isDisposing = true;
    super.dispose();
  }
}