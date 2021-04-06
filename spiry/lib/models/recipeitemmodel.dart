
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum RecipeQuery{ Diet, Cuisine, Type, Specific, Favourites}
extension RecipeQueryExtension on RecipeQuery {
  String get value {
    switch (this) {
      case RecipeQuery.Diet:
        return 'Diet';
      case RecipeQuery.Cuisine:
        return 'Cuisine';
      case RecipeQuery.Type:
        return 'Meal Type';
      case RecipeQuery.Specific:
        return 'Query';
      case RecipeQuery.Favourites:
        return 'Favourites';
      default:
        return null;
    }
  }
}

class RecipeModelList {
  List<RecipeItemModel> recipes;
  int number;
  int totalResults;

  RecipeModelList({this.recipes, this.number, this.totalResults});

  factory RecipeModelList.fromJson(Map<String, dynamic> json) {
    List<RecipeItemModel> rec = [];
    json['results'].forEach((v) {
      rec.add(RecipeItemModel.fromJson(v));
    });
    return RecipeModelList(
        recipes: rec,
        number: json['number'],
        totalResults: json['totalResults']
    );
  }
}


class RecipeItemModel extends Equatable{
  int preparationMinutes;
  int cookingMinutes;
  int recipeID;
  String title;
  String randCategory;
  int readyInMinutes;
  int servings;
  String sourceUrl;
  String image;
  String imageType;
  String summary;
  List cuisines;
  List dishTypes;
  List diets;
  List<AnalyzedInstructionModel> analyzedInstructions;

  RecipeItemModel(
      {this.preparationMinutes,
        this.cookingMinutes,
        this.recipeID,
        this.title,
        this.randCategory,
        this.readyInMinutes,
        this.servings,
        this.sourceUrl,
        this.image,
        this.imageType,
        this.summary,
        this.cuisines,
        this.dishTypes,
        this.diets,
        this.analyzedInstructions
      });

  factory  RecipeItemModel.fromJson(Map<String, dynamic> json){
    List<AnalyzedInstructionModel> analz =[];
    json['analyzedInstructions'].forEach((v) {
      analz.add(AnalyzedInstructionModel.fromJson(v));
    });
    List dishTyp = json['dishTypes'];
    String cat = "";
    if(json['cheap'])
      cat = "cheap";
    else if (json['dairyFree'])
      cat = "dairyFree";
    else if(json['veryHealthy'])
      cat = "veryHealthy";
    else if(json['veryPopular'])
      cat = "veryPopular";
    else if(json['sustainable'])
      cat = "sustainable";
    else if(json['lowFodmap'])
      cat = "lowFodmap";
    else {
      try {
        int rand = Random().nextInt(dishTyp.length);
        cat = dishTyp.isNotEmpty ? dishTyp[rand] : "Recipe";
      } on Exception catch (e) {
        // TODO
      }
    }

    return RecipeItemModel(
        preparationMinutes : json['preparationMinutes'],
        cookingMinutes :json['cookingMinutes'],
        recipeID : json['id'],
        title : json['title'],
        randCategory: cat,
        readyInMinutes : json['readyInMinutes'],
        servings : json['servings'],
        sourceUrl : json['sourceUrl'],
        image : json['image'],
        imageType : json['imageType'],
        summary : json['summary'],
        cuisines : json['cuisines'],
        dishTypes : dishTyp,
        diets : json['diets'],
      analyzedInstructions: analz
    );
  }

  factory RecipeItemModel.fromFireStore(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    List<AnalyzedInstructionModel> analz =[];
    data['analyzedInstructions'].forEach((v) {
      analz.add(AnalyzedInstructionModel.fromJson(v, fire: true));
    });
    return RecipeItemModel(
        preparationMinutes : data['preparationMinutes'],
        cookingMinutes :data['cookingMinutes'],
        recipeID : data['recipeID'],
        title : data['title'],
        randCategory: data['randCategory'],
        readyInMinutes : data['readyInMinutes'],
        servings : data['servings'],
        sourceUrl : data['sourceUrl'],
        image : data['image'],
        imageType : data['imageType'],
        summary : data['summary'],
        cuisines : data['cuisines'],
        dishTypes : data['dishTypes'],
        diets : data['diets'],
        analyzedInstructions: analz
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "preparationMinutes": preparationMinutes,
      "cookingMinutes": cookingMinutes,
      "recipeID": recipeID,
      "title": title,
      "randCategory": randCategory,
      "readyInMinutes": readyInMinutes,
      "servings": servings,
      'sourceUrl': sourceUrl,
      "image": image,
      "imageType": imageType,
      "summary": summary,
      'cuisines': cuisines,
      'dishTypes': dishTypes,
      "diets": diets,
      'analyzedInstructions': analyzedInstructions.map((v) => v.toJson()).toList()
    };
  }

  @override
  // TODO: implement props
  List<Object> get props => [recipeID];
}

class AnalyzedInstructionModel{
  String name;
  List<Step> steps;

  AnalyzedInstructionModel({this.name,this.steps});

  factory AnalyzedInstructionModel.fromJson(Map<String, dynamic> json, {bool fire = false}){
    List<Step> s = [];
    if(fire){
      json['steps'].forEach((v) {
        s.add(Step.fromFireStore(v));
      });
    }else{
      json['steps'].forEach((v) {
        s.add(Step.fromJson(v));
      });
    }
    return AnalyzedInstructionModel(
      name: json['name'],
      steps: s
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "name":name,
      "steps":steps.map((e) => e.toJson()).toList()
    };
  }


}

class Step{
  int number;
  String step;
  List ingredients;
  List equipment;
  String duration;

  Step({this.number,this.step,this.ingredients,this.equipment,this.duration});

  factory Step.fromFireStore(Map<String, dynamic> json){
    return Step(
      number: json['number'],
        step : json['step'],
      ingredients: json['ingredients'],
      equipment: json['equipment'],
      duration: json['duration']
    );
  }
  factory Step.fromJson(Map<String, dynamic> json){
    List<String> ing = [];
    json['ingredients'].forEach((v) {
      ing.add(v['name']);
    });
    List<String> equip = [];
    json['equipment'].forEach((v) {
      equip.add(v['name']);
    });
    return Step(
        number: json['number'],
        step : json['step'],
        ingredients: ing,
        equipment: equip,
        duration: json['length']  != null ? "${json['length']["number"]} ${json['length']['unit']}" : ""
    );
  }


  Map<String, dynamic> toJson(){
    return {
      "number": number,
      "step": step,
      "ingredients": ingredients,
      "equipment": equipment,
      "duration": duration
    };
  }

}