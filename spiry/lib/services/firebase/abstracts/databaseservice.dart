import 'dart:io';

import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/models/pantry.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/models/recipeitemmodel.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/models/usermodel.dart';

abstract class DatabaseService {
  Future<void> addUser(UserModel user);//unique
  Future<void> updateUser(Map<String,dynamic> userMap);
  Future<void> editUsername(UserModel user, String newUsername);
  Future<void> removeUser();
  Stream<UserModel> userStream();
  Future<UserModel> getUser();


  Future<void> addPantry(String pantryName);
  Future<void> removePantry(PantryModel pantryModel);
//  Stream<<PantryModel>> pantryStream();
  Future<List<PantryModel>> getPantries(UserModel userModel);

  Future<void> addCategory(CategoryModel categoryModel);
  Future<void> updateCategory(CategoryModel categoryModel,String newName);
  Future<void> removeCategory(CategoryModel categoryModel);
  Stream<List<CategoryModel>> categoryStream();
  Future<List<CategoryModel>> getCategories();

  Future<void> addProduct(ProductModel productModel);
  Future<void> removeProduct(ProductModel productModel);
  Future<void> updateProduct(ProductModel productModel);
  Stream<List<ProductModel>> productStream();
  Future<List<ProductModel>> getProducts();

  Future<void> addShoppingList(ShoppingListModel shoppingListModel);
  Future<void> removeShoppingList(String shoppingId);
  Future<void> updateShoppingList(ShoppingListModel shoppingListModel);
  Stream<List<ShoppingListModel>> shoppingStream();
  Future<void> addItemToShoppingList(ShoppingListModel shoppingListModel, {int index, var grocery, bool exist});
  Stream<ShoppingListModel> currentShoppingDocumentStream(String shoppingId);
  Future<List<ShoppingListModel>> getShoppingList();

  Future<void> addRecipe(RecipeItemModel recipeItemModel);
  Future<void> removeRecipe(RecipeItemModel recipeItemModel);
  Future<void> updateRecipe(RecipeItemModel recipeItemModel);
  Stream<List<RecipeItemModel>> recipeStream();




  Future<String> uploadFile(File file,String filename);
  Future<void> deleteFile(String filename);
}