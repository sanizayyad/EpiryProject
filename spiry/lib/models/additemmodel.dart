import 'package:spiry/services/navigation/routepaths.dart';
import 'package:flutter/material.dart';

class AddItemModel{
  final color;
  final String title;
  final String route;

  AddItemModel({this.color, this.title,this.route});

  static List<AddItemModel> addItems(){
    return <AddItemModel>[
      AddItemModel(
        color: Colors.pink,
        title: "Scan reciepts",
        route: ""
      ),
      AddItemModel(
        color: Colors.green,
        title: "Scan barcode",
        route: productAddEdit
      ),
      AddItemModel(
        color: Colors.blue,
        title: "Add Shopping list",
        route: shoppingAddEdit
      ),
      AddItemModel(
        color: Colors.deepOrange,
        title: "Add recipe",
        route: ""
      )
    ];
  }
}