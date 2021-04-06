
import 'package:spiry/models/recipeitemmodel.dart';

abstract class AbstractRecipe{
  Future<RecipeModelList> getRecipe(String name);
  Future<RecipeModelList> getDiets(String diet);
  Future<RecipeModelList> getCuisines(String cuisine);
  Future<RecipeModelList> getMealType(String type);

}