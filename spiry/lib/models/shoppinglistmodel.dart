import 'package:cloud_firestore/cloud_firestore.dart';


class ShoppingListModel{
  String title;
  String shoppingID;
  String color;
  String entryDate;
  String description;
  List<GroceryModel> items;

  ShoppingListModel({this.title,this.shoppingID,this.items,this.color,this.entryDate,this.description});

  factory ShoppingListModel.fromFireStore(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    List item = data['items'];
    return ShoppingListModel(
      shoppingID: snapshot.documentID,
      title: data['title'],
      items: item.map((item)=>GroceryModel.fromMap(item)).toList(),
      color: data['color'],
      entryDate: data['entryDate'],
      description: data['description']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title?.trim() ?? '',
      "items": items?.map((item)=>item.toJson())?.toList() ?? [],
      "color": color ?? '',
      "entryDate": entryDate ?? '',
      "description": description ?? ''
    };
  }
}


class GroceryModel{
  String groceryName;
  bool isBought;
  int quantity;
  GroceryModel({this.groceryName,this.isBought,this.quantity});

  factory GroceryModel.fromMap(Map data){
    return GroceryModel(
        groceryName: data['groceryName'],
        isBought: data['isBought'],
        quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "groceryName": groceryName ?? '',
      "isBought": isBought ?? false,
      "quantity": quantity ?? 1,
    };
  }
}

