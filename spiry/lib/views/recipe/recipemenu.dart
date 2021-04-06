import 'package:flutter/material.dart';
import 'package:spiry/models/recipeitemmodel.dart';
import 'package:spiry/models/recipemenumodel.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/pantry/selectpantry.dart';
import 'package:spiry/views/recipe/recipeprovider.dart';
import 'package:spiry/views/recipe/searchspace.dart';

import '../../locator.dart';

class Recipes extends StatefulWidget {
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  var recipeProv = locator<RecipeProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PantryLogo(),
        title: Text(
          "Recipe",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
          ),
        ),
        actions: [
          StreamBuilder<List<RecipeItemModel>>(
            stream: recipeProv.fireStoreService.recipeStream(),
              builder: (context, snapshot){
              if(snapshot.hasData) {
                recipeProv.favourites = snapshot.data;
              }
                return InkWell(
                  onTap: (){
                    recipeProv.getRecipes(RecipeQuery.Favourites, "");
                     recipeProv.navigationService.pushNamed(recipeList,arguments: [RecipeQuery.Favourites.value]);
                  },
                  child: Stack(
                    children: [
                      Container(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.favorite_border, color: primaryColor,size: 30,)),
                      recipeProv.favourites.isNotEmpty ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Center(
                            child: Text(recipeProv.favourites.length.toString(),style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                        ),
                      ): Container()
                    ],
                  ),
                );
              }),
          SizedBox(
            width: 4,
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: greyBg,
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 16),
          children: [
            SearchSpace(),
            RecipeSection(
              titleQuery: RecipeQuery.Diet,
              info: true,
              recipeMenu: RecipeMenuModel.diet(),
            ),
            RecipeSection(
              titleQuery: RecipeQuery.Cuisine,
              recipeMenu: RecipeMenuModel.cuisine(),
            ),
            RecipeSection(
              titleQuery: RecipeQuery.Type,
              recipeMenu: RecipeMenuModel.mealType(),
            ),
            SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeSection extends StatelessWidget {
  final RecipeQuery titleQuery;
  final List<RecipeMenuModel> recipeMenu;
  final bool info;

  RecipeSection({this.titleQuery, this.info = false, this.recipeMenu});

  Widget item(BuildContext context, RecipeMenuModel model) {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: (){
                locator<RecipeProvider>().getRecipes(titleQuery, model.title);
                locator<RecipeProvider>()
                    .navigationService.pushNamed(recipeList,arguments: [model.title]);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.16,
                width: MediaQuery.of(context).size.height * 0.15,
                margin: EdgeInsets.only(
                    left: 16,
                    right: model == recipeMenu.last ? 16 : 0,
                    bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 0, // has the effect of softening the shadow
                        offset: Offset(1, 1.0),
                      )
                    ],
                    image: DecorationImage(
                        image: AssetImage(model.image),
                        fit: BoxFit.cover)),
              ),
            ),
            info
                ? Positioned(
                    right: model == recipeMenu.last ? 21 : 5,
                    top: 5,
                    child: InkWell(
                      onTap: () {
                        locator<RecipeProvider>()
                            .infoDialog(context, model.info);
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          model.title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            titleQuery.value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: double.infinity,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: recipeMenu.map((e) => item(context, e)).toList(),
            ))
      ],
    );
  }
}
