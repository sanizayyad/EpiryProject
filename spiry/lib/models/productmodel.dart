import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ProductModel extends Equatable{
  final String productID;
  final String productName;
  String imageUrl;
  final String category;
  final String barcode;
  final String entryDate;
  final String expiryDate;
  final String description;

  ProductModel(
      {this.productID,
        this.productName,
        this.imageUrl,
        this.category,
        this.barcode,
        this.entryDate,
        this.expiryDate,
        this.description
      });

  factory ProductModel.fromFireStore(DocumentSnapshot snapshot) {
    Map data = snapshot.data;
    return ProductModel(
        productID: snapshot.documentID,
        productName: data['productName'],
        imageUrl: data['imageUrl'],
        category: data['category'],
        barcode: data['barcode'],
        entryDate: data['entryDate'],
        expiryDate: data['expiryDate'],
        description: data['description']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productName": productName?.trim() ?? '',
      "imageUrl": imageUrl,
      "category": category?.trim(),
      "barcode": barcode ?? '',
      "entryDate": entryDate ?? '',
      "expiryDate": expiryDate ?? '',
      'description': description ?? ''
    };
  }

  @override
  // TODO: implement props
  List<Object> get props => [barcode];
}

class ProductState{
  String state;
  Color color;

  ProductState({this.state,this.color});

  static List<ProductState> productStates(){
    return  [
      ProductState(
          state: "Expired products",
          color: Colors.red
      ),
      ProductState(
          state: "Soon to expire",
          color: Colors.orange
      ),
      ProductState(
          state: "Good products",
          color: Colors.green
      ),
    ];
  }
}
