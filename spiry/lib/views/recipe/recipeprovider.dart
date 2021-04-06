
import 'package:flutter/material.dart';
import 'package:spiry/models/recipeitemmodel.dart';
import 'package:spiry/services/recipe/abstract.dart';
import 'package:spiry/services/recipe/recipeservice.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';

import '../../locator.dart';


class RecipeProvider extends BaseProviderModel{
  final RecipeService _recipeService = locator<AbstractRecipe>();

  List<RecipeItemModel> recipeModelList = [];
  List<RecipeItemModel> favourites = [];
  RecipeQuery currentQuery;
  String endPoint = '';

  Future<void> getRecipes(RecipeQuery query, String value) async{
    setViewState(ViewState.Busy);
    if(currentQuery != query || endPoint != value){
      switch (query) {
        case RecipeQuery.Diet:
          await _recipeService.getDiets(value).then((value){
            recipeModelList = value.recipes;
          });
          break;
        case RecipeQuery.Cuisine:
          await _recipeService.getCuisines(value).then((value){
            recipeModelList = value.recipes;
          });
          break;
        case RecipeQuery.Type:
          await _recipeService.getMealType(value).then((value){
            recipeModelList = value.recipes;
          });
          break;
        case RecipeQuery.Specific:
          await _recipeService.getRecipe(value).then((value){
            recipeModelList = value.recipes;
          });
          break;
        case RecipeQuery.Favourites:
          recipeModelList = favourites;
          break;
        default:
          return null;
      }
      currentQuery = query;
      endPoint = value;
    }
    Future.delayed(Duration(seconds: 5));
    setViewState(ViewState.Idle);
  }

  Future<bool> infoDialog(BuildContext context,String info) async{
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(info, style: TextStyle(
                        fontSize: 18,
                        color: primaryColor,
                        fontWeight: FontWeight.bold
                    ),),
                  )
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    navigationService.pop(false);
                  },
                  child: Text('Ok'),
                ) ,
              ],
            )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
//    super.dispose();
  }
}