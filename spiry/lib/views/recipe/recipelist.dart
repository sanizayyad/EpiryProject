import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/datetag.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/recipeitemmodel.dart';
import 'package:spiry/services/navigation/navigationservice.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/recipe/recipeprovider.dart';

class RecipeList extends StatelessWidget {
  final arguments;
  RecipeList({this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments[0],
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: (){
            locator<NavigationService>().pop(true);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: ImageIcon(AssetImage('images/filter.png'),
                size: 24, color: primaryColor),
          ),
          SizedBox(
            width: 4,
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<RecipeProvider>(
          create: (BuildContext context) => locator<RecipeProvider>(),
        child: Consumer<RecipeProvider>(
          builder: (_,recipeProvider,child){
            return Center(
              child: recipeProvider.viewState == ViewState.Busy
                  ? BusyLoading(type: 'orange',)
                  : recipeProvider.recipeModelList.isEmpty
                  ?  Center(child: Text("No recipes found",style: TextStyle(
                fontSize: 25
              ),),)
                  : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: recipeProvider.recipeModelList.map((e) => ListItem(recipeItemModel: e,)).toList(),
              )
            );
          },
        ),
      )
    );
  }
}

class ListItem extends StatelessWidget {
  final RecipeItemModel recipeItemModel;
  ListItem({this.recipeItemModel});
  @override
  Widget build(BuildContext context) {
    var prov = locator<RecipeProvider>();
    var category = ![RecipeQuery.Specific,RecipeQuery.Favourites].contains(prov.currentQuery)
        ? prov.endPoint : recipeItemModel.randCategory;
    bool isLiked  = prov.favourites.contains(recipeItemModel);
      return InkWell(
      onTap: () {
        print(recipeItemModel.title);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            height: 100,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/imageloading.gif',
                      image: recipeItemModel.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DateTag(
                        expiryDate: recipeItemModel.recipeID.toString(),
                        category: category,
                        whiteOnblack: false,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        recipeItemModel.title,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Ready in ${recipeItemModel.readyInMinutes} minutes',
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.6),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          InkWell(
                             onTap: ()async{
                               if(isLiked){
                                 await prov.fireStoreService.removeRecipe(recipeItemModel);
                               }else{
                                 await prov.fireStoreService.addRecipe(recipeItemModel);
                               }
                               prov.setViewState(ViewState.Idle);
                             },
                              child: Icon(
                                isLiked ? Icons.favorite: Icons.favorite_border,
                                color: isLiked ? Colors.red : primaryColor,))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
