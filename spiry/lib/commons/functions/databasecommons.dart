
import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/models/pantry.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

void showToast(message,context){
  Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity:  Toast.BOTTOM);
}


DateTime stringToDate(string){
  DateFormat dateFormat = DateFormat.yMMMd();
  return dateFormat.parse(string);
}

List<String> mapCategoriesString(List<CategoryModel> cats){
  return cats.map((category) => category.categoryName).toList();
}



void removeSnack(context){
  Scaffold.of(context).removeCurrentSnackBar();
}

int daysLeft(exp){
  DateTime expiry = stringToDate(exp);
  return expiry.difference(DateTime.now()).inDays;
}

//void sortCategories(List<CategoryModel> list){
//  list?.sort((a,b)=>a.categoryName.toLowerCase().compareTo(b.categoryName.toLowerCase()));
//}

void sortPantries(List<PantryModel> list){
  list?.sort((a, b) => a.pantryName.toLowerCase().compareTo(b.pantryName.toLowerCase()));
}
void sortProducts(List<ProductModel> list){
  list?.sort((a, b) => stringToDate(a.expiryDate).compareTo(stringToDate(b.expiryDate)));
}
void sortShoppingList(List<ShoppingListModel> list, order) {
  if (order)
    list?.sort((a, b) => stringToDate(a.entryDate).compareTo(stringToDate(b.entryDate)));
  else
    list?.sort((b, a) => stringToDate(a.entryDate).compareTo(stringToDate(b.entryDate)));
}

ProductState determineState(int daysLeft){
  if (daysLeft < 1)
    return ProductState(
        state: "expired",
        color: Colors.red
    );
  else if(daysLeft < 5)
    return ProductState(
        state: "$daysLeft days left",
        color: Colors.orange
    );
  else
    return ProductState(
        state: "$daysLeft days left",
        color: Colors.green
    );
}
