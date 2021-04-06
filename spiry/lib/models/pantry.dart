import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';


class PantryModel extends Equatable{
  String pantryName;
  String path;
  Map members;
  String dateCreated;
  int numberOfCategories;
  int numberOfProducts;
  int numberOfShoppingList;
  Map deepLinkExpiration;

  PantryModel({
    this.pantryName,
    this.path,
    this.members,
    this.dateCreated,
    this.numberOfCategories,
    this.numberOfProducts,
    this.numberOfShoppingList,
    this.deepLinkExpiration
});

  factory PantryModel.fromFireStore(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    return PantryModel(
      pantryName: data["pantryName"],
      path: data["path"],
      members: data["members"],
      dateCreated: data["dateCreated"],
      numberOfCategories: data["numberOfCategories"],
      numberOfProducts: data["numberOfProducts"],
      numberOfShoppingList: data["numberOfShoppingList"],
      deepLinkExpiration: data["deepLinkExpiration"],
    );
  }

//  Map<String,dynamic> toJson(){
//    return{
//      "pantryName": pantryName?.trim(),
//      "members": members ?? {},
//      "dateCreated":dateCreated ?? DateFormat.yMMMd().format(DateTime.now()),
//      "numberOfCategories":numberOfCategories ?? "000",
//      "numberOfProducts":numberOfProducts ?? "000",
//      "numberOfShoppingList": numberOfShoppingList ?? '000',
//      "deepLinkExpiration": deepLinkExpiration ?? {}
//    };
//  }
  @override
  // TODO: implement props
  List<Object> get props => [members,numberOfCategories, numberOfProducts, numberOfShoppingList,deepLinkExpiration];

}