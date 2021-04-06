import 'package:spiry/models/recipeitemmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'abstract.dart';

class RecipeService implements AbstractRecipe{
  static const String API_KEY = "5ecfebbe4df44a419cd5a14d85c30622";
  static const String _apiComplex= "https://api.spoonacular.com/recipes/complexSearch?apiKey=$API_KEY&addRecipeInformation=true&number=20";



  @override
  Future<RecipeModelList> getRecipe(String name) async{
    String request = "$_apiComplex&query=$name";
    var response = await http.get(request);
    if (response.statusCode == 200) {
      return RecipeModelList.fromJson(jsonDecode(response.body));
    }else {
      throw Exception('Unable to fetch recipes from the REST API');
    }
  }
  
  @override
  Future<RecipeModelList> getCuisines(String cuisine) async{
    String request = "$_apiComplex&cuisine=$cuisine";
    var response = await http.get(request);
    if (response.statusCode == 200) {
      return RecipeModelList.fromJson(jsonDecode(response.body));
    }else {
      throw Exception('Unable to fetch recipes from the REST API');
    }
  }

  @override
  Future<RecipeModelList> getDiets(String diet) async{
    String request = "$_apiComplex&diet=$diet";
    var response = await http.get(request);
    if (response.statusCode == 200) {

      return RecipeModelList.fromJson(jsonDecode(response.body));
    }else {
      throw Exception('Unable to fetch recipes from the REST API');
    }
  }

  @override
  Future<RecipeModelList> getMealType(String type) async{
    String request = "$_apiComplex&type=$type";
    var response = await http.get(request);
    if (response.statusCode == 200) {
      return RecipeModelList.fromJson(jsonDecode(response.body));
    }else {
      throw Exception('Unable to fetch recipes from the REST API');
    }
  }

}