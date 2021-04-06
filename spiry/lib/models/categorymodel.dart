import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  final String categoryName;
  final String path;

  CategoryModel({this.categoryName,this.path});

  factory CategoryModel.fromFireStore(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    return CategoryModel(
        categoryName: data['categoryName'],
        path: data['path']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'categoryName': categoryName?.trim()
    };
  }

}