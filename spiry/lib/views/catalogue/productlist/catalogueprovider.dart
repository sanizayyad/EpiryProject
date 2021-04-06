import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/widgets/tabitemcontainer.dart';
import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/models/pantry.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/services/firebase/abstracts/authenticationservice.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/authentication/authenticationprovider.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/catalogue/filter/filterprovider.dart';
import 'package:spiry/views/catalogue/productdetails/productaddeditprovider.dart';
import 'package:spiry/views/pantry/pantryprovider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sortedmap/sortedmap.dart';

import '../../../locator.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class CatalogueProvider extends BaseProviderModel{
  String currentCategoryFilter = "All Products";
  List<ProductModel> products = [];
  List<ProductModel> selectedProducts = [];
  List<String> categoriesList = [];
  BuildContext productsContext;
  bool viewTypeList = true;
  bool userDeleted = false;

  void changeView(){
    viewTypeList = !viewTypeList;
    setViewState(ViewState.Idle);
  }
  List<String> mapCategoriesList(categoriesSnapshot){
    categoriesList = mapCategoriesString(categoriesSnapshot);
    List<CategoryModel> _categories = [
      CategoryModel(categoryName: "All Products"),
      CategoryModel(categoryName: "Edit"),
    ];
    _categories.insertAll(1, categoriesSnapshot);
    List<String> catList = mapCategoriesString(_categories);

    Future.delayed(Duration(milliseconds: 150)).then((value) async{
      if(!catList.contains('uncategorized')){
        if(!userDeleted)
          locator<AuthenticationProvider>().signOut();

//        int index = pantryProv.pantries.indexWhere((pantry) => pantry.pantryName == pantryProv.currentPantry);
//        pantryProv.pantries.removeAt(index);
//        showToast("${pantryProv.currentPantry} has been deleted by the Admin of the Pantry", productsContext);
//        await pantryProv.changePantry("Default Pantry");
//        await navigationService.pushReplacementNameUntil(selectPantry);
      }
    });
    return catList;
  }

  void updateFilteredCategory(String filter){
    if(currentCategoryFilter != filter){
      currentCategoryFilter = filter;
      setViewState(ViewState.Idle);
    }
  }
  void onCategoryTap(int index,List<String> categories,context) async{
    if(categories[index] == "Edit"){
      navigationService.pushNamed(categoryAddEdit).then((value){
        DefaultTabController.of(context).animateTo(0);
        updateFilteredCategory("All Products");
      });
    }
    else if(categories[index] != currentCategoryFilter)
      updateFilteredCategory(categories[index]);
  }

  List filterProducts(List<ProductModel> products){
    sortProducts(products);
    if (currentCategoryFilter == "All Products")
      return products;
    return products.where((item)=> item.category == currentCategoryFilter).toList() ?? [];
  }

  Future<void> navigateAddOrEditProduct(ProductModel productModel) async{
    if(categoriesList.isEmpty)
      categoriesList = mapCategoriesString(await fireStoreService.getCategories());
    navigationService.pushNamed(productAddEdit,arguments: [productModel,categoriesList]);
  }

  Future<void> navigateToFilter() async{
    List<PantryModel> pantries = locator<SelectPantryProvider>().pantries;
    if(pantries.isEmpty)
      pantries = await fireStoreService.getPantries(locator<SelectPantryProvider>().userModel);
    var pant = pantries.map((pant) => pant.pantryName).toList();
    String initialPantry = locator<SelectPantryProvider>().currentPantry;
    navigationService.pushReplacementName(filterScreen, arguments: [pant,initialPantry]);
  }


  void dismissed(direction, productModel) async{
    if (direction == DismissDirection.startToEnd) {
      bool undo = false;
      removeSnack(productsContext);
      await fireStoreService.removeProduct(productModel,removeCache: false);
      Scaffold.of(productsContext).showSnackBar(
        SnackBar(
          content: Text("Product deleted!. Do you want to undo?"),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
              label: "Undo",
              textColor: Colors.yellow,
              onPressed: () async{
                undo = true;
                var file = await DefaultCacheManager().getSingleFile(productModel.imageUrl);
                String imageUrl = await fireStoreService.uploadFile(file, productModel.barcode);
                productModel.imageUrl = imageUrl;
               await fireStoreService.addProduct(productModel);
              }),
        ),
      );
      await Future.delayed(Duration(seconds: 4));
      if(!undo){
        var file = await DefaultCacheManager().getSingleFile(productModel.imageUrl);
        await file.delete();
      }
    } else {
      navigateAddOrEditProduct(productModel);
    }
  }

  Map<int,List<ProductModel>> sortDaysLeft(List<ProductModel> productsList){
    Map<int,List<ProductModel>> sorted = new SortedMap(Ordering.byKey());

    for(var prod in productsList){
      int days = daysLeft(prod.expiryDate);
      if(days < 2 ){
        if(sorted[0] != null)
          sorted[0].add(prod);
        else
          sorted[0] = [prod];
        continue;
      }

      if(sorted.containsKey(days)){
        sorted[days].add(prod);
      }else{
        sorted[days] = [prod];
      }
    }
    return sorted;
  }


  void onProductTap(ProductModel productModel){
    if(selectedProducts.isNotEmpty){
      if(selectedProducts.contains(productModel))
        unselect(productModel);
      else
        select(productModel);
    }else{
      navigateAddOrEditProduct(productModel);
    }
  }

  void select(ProductModel productModel){
    selectedProducts.add(productModel);
    setViewState(ViewState.Idle);
  }
  void unselect(ProductModel productModel){
    selectedProducts.remove(productModel);
    setViewState(ViewState.Idle);
  }
  void emptySelected(){
    selectedProducts = [];
    setViewState(ViewState.Idle);
  }
  void addSubList(List<ProductModel> sub){
    sub.forEach((element) {
      if(!selectedProducts.contains(element))
        selectedProducts.add(element);
    });
    setViewState(ViewState.Idle);
  }
  void removeSubList(List<ProductModel> sub){
    sub.forEach((element) {
      selectedProducts.remove(element);
    });
    setViewState(ViewState.Idle);
  }
  bool checkSubList(List<ProductModel> sub){
     for(ProductModel prod  in sub){
       if(!selectedProducts.contains(prod)){
         return false;
       }
     }
      return true;
}
  Future<bool> addSelectedShoppingList(BuildContext context,List<ProductModel> products) async{
    List<ShoppingListModel> shopList = await fireStoreService.getShoppingList();
    List<bool> checkedShoppingList = shopList.map((e) => false).toList();

    String message = shopList.isNotEmpty
        ? "Check the following shopping list to add ${products.length} selected product(s)"
        : "Sorry there's no shopping list, create a new shopping list and try again";
    return showDialog(
        context: context,
        builder: (_) =>
            StatefulBuilder(
                builder: (context,setState){
                  return AlertDialog(
                    content: Container(
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(message, style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            SizedBox(height: 16,),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Column(
                                  children:  shopList.map((shop){
                                    return InkWell(
                                      onTap: (){
                                        setState(() {
                                          checkedShoppingList[shopList.indexOf(shop)] = !checkedShoppingList[shopList.indexOf(shop)];
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: 37,
                                            height: 37,
                                            child: Checkbox(
                                              activeColor: Colors.green,
                                              value: checkedShoppingList[shopList.indexOf(shop)],
                                              onChanged: (bool value) {
                                                setState(() {
                                                  checkedShoppingList[shopList.indexOf(shop)] = !checkedShoppingList[shopList.indexOf(shop)];                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Text(shop.title,style: TextStyle(
                                              fontSize: 16
                                          ),)
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ),
                          ],
                        )
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
                    actions: <Widget>[
                      shopList.isNotEmpty ? FlatButton(
                        onPressed: () async {
                          navigationService.pop(true);
                          for(ShoppingListModel shoppingListModel in shopList){
                            if(checkedShoppingList[shopList.indexOf(shoppingListModel)] == true)
                             products.forEach((product) async{
                               await fireStoreService.addItemToShoppingList(
                                 shoppingListModel,
                                 grocery: GroceryModel(
                                     groceryName: product.productName,
                                     isBought: false,
                                     quantity: 1
                                 ),
                               );
                             });
                            showToast("Added successfully!", context);
                          }
                        },
                        child: Text('Confirm'),
                      ) : Container(),
                       FlatButton(
                        onPressed: () {
                          navigationService.pop(false);
                        },
                        child: Text('Cancel'),
                      ) ,
                    ],
                  );
                })
    );
  }

  List<Widget> appbarActions(BuildContext context){
    List<Widget> defaultAction(){
      return [
        IconButton(
          icon: Icon(!viewTypeList
              ? FontAwesomeIcons.listAlt
              : FontAwesomeIcons.gripVertical),
          color: primaryColor,
          iconSize: 24,
          onPressed: (){
            changeView();
          },
        ),
        IconButton(
          onPressed: () {
            navigateToFilter();
          },
          icon: ImageIcon(AssetImage('images/filter.png'),
              size: 24, color: primaryColor),
        ),
        SizedBox(width: 16)
      ];
    }
    List<Widget> selectAction(BuildContext context){
      return [
        IconButton(
          icon: Icon(Icons.add_shopping_cart),
          color: Colors.green,
          iconSize: 24,
          onPressed: ()async{
            await addSelectedShoppingList(context,selectedProducts);
            emptySelected();
          },
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.delete),
          color: primaryColor,
          iconSize: 24,
          onPressed: () async{
            await ProductAddEditProvider().deleteDialog(context, selectedProducts, false);
            emptySelected();
          },
        ),
        SizedBox(width: 16)
      ];
    }

    return selectedProducts.isEmpty
        ? defaultAction()
        :selectAction(context);
  }
}


