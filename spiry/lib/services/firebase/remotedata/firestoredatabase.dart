import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/models/pantry.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/models/recipeitemmodel.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/models/usermodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spiry/services/firebase/abstracts/databaseservice.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FireStoreService implements DatabaseService {
  final String userInformationCollection = "userinformation";
  final String pantryCollection = "pantrycollection";
  final String productsCollection = "products";
  final String categoriesCollection = "categories";
  final String shoppingListCollection = "shoppinglist";
  final String recipeCollection = "recipes";

  CollectionReference _userInformationReference; //base
  CollectionReference _productsCollection;
  CollectionReference _categoriesCollection;
  CollectionReference _shoppingListCollection;
  CollectionReference _recipeCollection;
  StorageReference _storageReference;
  UserModel _user;

  void startFireStore(UserModel user) {
    _user = user;
    _userInformationReference =
        Firestore.instance.collection(userInformationCollection);
    _storageReference = FirebaseStorage.instance.ref();
  }

  Future<void> changePantry(String currentPantry, UserModel userModel) async {
    Future<UserModel> recursive()async{
      UserModel userModel = await getUser();
      if(userModel.pantriesReference.isNotEmpty)
        return userModel;
      return recursive();
    }

    if(userModel == null || userModel.pantriesReference.isEmpty)
      _user =  await recursive();
    else
      _user = userModel;
    DocumentReference reference = Firestore.instance.document(_user.pantriesReference[currentPantry]);
    _productsCollection = reference.collection(productsCollection);
    _categoriesCollection = reference.collection(categoriesCollection);
    _shoppingListCollection = reference.collection(shoppingListCollection);
    _recipeCollection = reference.collection(recipeCollection);
  }

  @override
  Future<void> addUser(UserModel user) async {
    try {
      user.reminders = NotificationReminders.reminders();
      user.expiryNotification = true;
      await _userInformationReference
          .document(user.userID)
          .setData(user.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> updateUser(Map<String,dynamic> userMap) async {
    try {
      await _userInformationReference
          .document(_user.userID)
          .updateData(userMap).catchError((err){print(err);});
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> editUsername(UserModel user, String newUsername) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'editUsername',
      );
      await callable.call(<String, dynamic>{
        'userID': user.userID,
        'oldUsername': user.username,
        'newUsername': newUsername
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> removeUser() async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'deleteUser',
      );
      await callable.call(<String, dynamic>{
        'userID': _user.userID,
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Stream<UserModel> userStream() {
    return _userInformationReference
        .document(_user.userID)
        .snapshots()
        .map((doc) => UserModel.fromFireStore(doc));
  }

  @override
  Future<UserModel> getUser() async {
    try {
      var user = await _userInformationReference.document(_user.userID).get();
      return UserModel.fromFireStore(user);
    } catch (e) {
      print(e.message);
    }
    return null;
  }

  @override
  Future<void> addPantry(String pantryName) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'createPantry',
      );
      await callable.call(
          <String, dynamic>{'userID': _user.userID, 'pantryName': pantryName});
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> removePantry(PantryModel pantryModel) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'deletePantry',
      );
      await callable.call(<String, dynamic>{
        'path': pantryModel.path,
        'pantryName': pantryModel.pantryName
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<List<PantryModel>> getPantries(UserModel userModel) async {
    userModel = userModel ?? await getUser();
    List<PantryModel> pantries = [];
    await Future.forEach(userModel.pantriesReference.entries, (MapEntry entry) async {
      PantryModel pantryModel;
      try {
        DocumentSnapshot snap = await Firestore.instance.document(entry.value).get();
        pantryModel = PantryModel.fromFireStore(snap);
      } catch (e) {
      }
      if (pantryModel != null) {
        pantries.add(pantryModel);
      }
    });
    sortPantries(pantries);
    return pantries;
  }

  @override
  Future<void> addCategory(CategoryModel categoryModel) async {
    try {
      await _categoriesCollection.document().setData(categoryModel.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> updateCategory(
      CategoryModel categoryModel, String newName) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'updateCategory',
      );
      await callable.call(
          <String, dynamic>{'path': categoryModel.path, 'newName': newName});
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> removeCategory(CategoryModel categoryModel) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'deleteCategory',
      );
      await callable.call(<String, dynamic>{
        'path': categoryModel.path,
      });
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Stream<List<CategoryModel>> categoryStream() {
    return _categoriesCollection.snapshots().map((list) =>
        list.documents.map((doc) => CategoryModel.fromFireStore(doc)).toList());
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _categoriesCollection.getDocuments();
      return snapshot.documents
          .map((doc) => CategoryModel.fromFireStore(doc))
          .toList();
    } catch (e) {
      print(e.message);
    }
    return null;
  }

  @override
  Future addProduct(ProductModel productModel) async {
    try {
      await _productsCollection.document().setData(productModel.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> updateProduct(ProductModel productModel) async {
    try {
      await _productsCollection
          .document(productModel.productID)
          .updateData(jsonUpdate(productModel));

    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> removeProduct(ProductModel productModel, {bool removeCache = true}) async {
    try {
      await _productsCollection.document(productModel.productID).delete();
      await deleteFile(productModel.barcode);
      if(removeCache){
        var file = await DefaultCacheManager().getSingleFile(productModel.imageUrl);
        await file.delete();
      }
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Stream<List<ProductModel>> productStream() {
    return _productsCollection.snapshots().map((list) =>
        list.documents.map((doc) => ProductModel.fromFireStore(doc)).toList());
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _productsCollection.getDocuments();
      return snapshot.documents
          .map((doc) => ProductModel.fromFireStore(doc))
          .toList();
    } catch (e) {
      print(e.message);
    }
    return null;
  }

  @override
  Future<void> addShoppingList(ShoppingListModel shoppingListModel) async {
    try {
      await _shoppingListCollection
          .document()
          .setData(shoppingListModel.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> updateShoppingList(ShoppingListModel shoppingListModel) async {
    try {
      await _shoppingListCollection
          .document(shoppingListModel.shoppingID)
          .updateData(jsonUpdate(shoppingListModel));
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> removeShoppingList(String shoppingId) async {
    try {
      await _shoppingListCollection.document(shoppingId).delete();
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Stream<List<ShoppingListModel>> shoppingStream() {
    return _shoppingListCollection.snapshots().map((list) => list.documents
        .map((doc) => ShoppingListModel.fromFireStore(doc))
        .toList());
  }

  @override
  Future<void> addItemToShoppingList(ShoppingListModel shoppingListModel,
      {int index, grocery, bool exist = false}) async {
    List<GroceryModel> groceries = shoppingListModel.items;
    if (exist) {
      groceries.removeAt(index);
      groceries.insert(index, grocery);
    } else {
      groceries.add(grocery);
    }
    await updateShoppingList(ShoppingListModel(
        shoppingID: shoppingListModel.shoppingID, items: groceries));
  }

  @override
  Stream<ShoppingListModel> currentShoppingDocumentStream(String shoppingId) {
    return _shoppingListCollection
        .document(shoppingId)
        .snapshots()
        .map((doc) => ShoppingListModel.fromFireStore(doc));
  }

  Future<List<ShoppingListModel>> getShoppingList() async {
    try {
      QuerySnapshot snapshot = await _shoppingListCollection.getDocuments();
      return snapshot.documents
          .map((doc) => ShoppingListModel.fromFireStore(doc))
          .toList();
    } catch (e) {
      print(e.message);
    }
    return null;
  }

  @override
  Future<String> uploadFile(File file, String fileName) async {
    String path = "${_user.email}/$fileName";
    StorageUploadTask uploadTask = _storageReference.child(path).putFile(file);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  @override
  Future<void> deleteFile(String fileName) async {
    String path = "${_user.email}/$fileName";
    await _storageReference.child(path).delete();
  }

  Map<String, dynamic> jsonUpdate(var model) {
    Map<String, dynamic> mapUpdates = {};
    model.toJson().forEach((key, value) {
      if (![null, "", "000"].contains(value) && value.isNotEmpty) {
        mapUpdates[key] = value;
      }
      else if (key == "items")
        mapUpdates[key] = value;

    });
    return mapUpdates;
  }

  @override
  Future<void> addRecipe(RecipeItemModel recipeItemModel) async{
    try {
      await _recipeCollection.document(recipeItemModel.recipeID.toString()).setData(recipeItemModel.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> removeRecipe(RecipeItemModel recipeItemModel) async{
    try {
      await _recipeCollection.document(recipeItemModel.recipeID.toString()).delete();
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Future<void> updateRecipe(RecipeItemModel recipeItemModel) async{
    try {
      await _recipeCollection
          .document(recipeItemModel.recipeID.toString())
          .updateData(jsonUpdate(recipeItemModel));
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Stream<List<RecipeItemModel>> recipeStream() {
    return _recipeCollection.snapshots().map((list) => list.documents
        .map((doc) => RecipeItemModel.fromFireStore(doc))
        .toList());
  }
}
