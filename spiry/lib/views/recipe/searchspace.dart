import 'package:flutter/material.dart';
import 'package:spiry/models/recipeitemmodel.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/recipe/recipeprovider.dart';

import '../../locator.dart';
class SearchSpace extends StatefulWidget {
  @override
  _SearchSpaceState createState() => _SearchSpaceState();
}

class _SearchSpaceState extends State<SearchSpace> {
  final TextEditingController _searchController = TextEditingController();

  void action(){
    locator<RecipeProvider>().getRecipes(RecipeQuery.Specific, _searchController.text.trim());
    locator<RecipeProvider>()
        .navigationService.pushNamed(recipeList,arguments: [_searchController.text.trim()]);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color:Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (var x){
                          setState(() {
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "Search recipe",
                          icon: Icon(Icons.fastfood,color: primaryColor,),
                        ),
                        onFieldSubmitted: (val){
                          if(val.isNotEmpty)
                            action();
                        },
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        _searchController.clear();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.clear,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IgnorePointer(
              ignoring: _searchController.text.isEmpty,
              child: Opacity(
                opacity: _searchController.text.isEmpty ? 0.4 : 1,
                child: InkWell(
                  onTap: (){
                    action();
                  },
                  child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Icon(Icons.search),
                      )),
                ),
              )
          )
        ],
      ),
    );
  }
}
