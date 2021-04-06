import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';

class ShoppingListProvider extends BaseProviderModel{
  bool order = false;
  BuildContext shopListContext;

  void changeOrder(){
    order = !order;
    setViewState(ViewState.Idle);
  }

  Future addOrEditNavigation(shoppingModel) async{
    if(shoppingModel != null){
      navigationService.pushNamed(shoppingAddEdit,arguments:[shoppingModel]);
    }
    else{
      navigationService.pushNamed(shoppingAddEdit);
    }
  }

  Future<void> dismissed(direction, shoppingModel) async {
    if (direction == DismissDirection.startToEnd) {
      fireStoreService.removeShoppingList(shoppingModel.shoppingID);
      removeSnack(shopListContext);
      Scaffold.of(shopListContext).showSnackBar(
        SnackBar(
          content: Text("List deleted!. Do you want to undo?"),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
              label: "Undo",
              textColor: Colors.yellow,
              onPressed: () {
                fireStoreService.addShoppingList(shoppingModel);
              }),
        ),
      );
    } else {
      await checkAll(shoppingModel);
    }
  }
  Future<bool> deleteListDialog(context, shoppingModel) {
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("Are you sure you want to delete this Shopping list"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    navigationService.pop(true);
                    fireStoreService.removeShoppingList(shoppingModel.shoppingID);
                    navigationService.pop(true);
                  },
                  child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: () {
                    navigationService.pop(false);
                  },
                  child: Text('No'),
                ),
              ],
            )
    );
  }

  Future<bool> addOrEditItemDialog(context,ShoppingListModel shoppingModel, GroceryModel groceryModel){
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();

    bool groceryExist = groceryModel != null;
    controller.text = groceryModel?.groceryName;
    int quantity = groceryExist ? groceryModel.quantity : 1 ;

    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  children: <Widget>[
                    Text(groceryExist ? "Edit item" :"Add item"),
                    Spacer(),
                    groceryExist ? IconButton(
                      onPressed: ()  {
                        clearItems(shoppingModel, groceryModel);
                        showToast("Item cleared successfully", context);
                        navigationService.pop(false);
                      },
                      icon: Icon(Icons.delete),color: colorGradient[shoppingModel.color][0],):SizedBox(),
                  ],
                ),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: controller,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: "Item name",
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),
                              focusColor: Colors.black,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)
                              )
                          ),
                          validator: itemNameValidator,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            onPressed: (){
                              setState(() {
                                if (quantity != 0)
                                  quantity --;
                              });
                            },
                            child: Icon(IconData(0xe15b, fontFamily: 'MaterialIcons'), color: Colors.black),),
                          Text('$quantity',
                              style: TextStyle(fontSize: 30.0)),
                          FlatButton(
                              onPressed: (){
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: Icon(Icons.add, color: Colors.black,)),
                        ],
                      ),
                    ],
                  ),
                ),
                titlePadding:  EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      if(formKey.currentState.validate()){
                        navigationService.pop(true);
                        int index = shoppingModel.items.indexOf(groceryModel);
                        addUpdateItem(shoppingModel, index, GroceryModel(
                            groceryName: controller.text,
                            isBought: groceryExist ? groceryModel.isBought : false,
                            quantity: quantity
                        ), groceryExist);
                        controller.clear();
                      }
                    },
                    child: Text('Confirm',style: TextStyle(
                        color: colorGradient[shoppingModel.color][0]
                    ),),
                  ),
                  FlatButton(
                    onPressed: () {
                      navigationService.pop(false);
                    },
                    child: Text('Cancel',style: TextStyle(
                        color: colorGradient[shoppingModel.color][0]
                    ),),
                  ),
                ],
              );
            })
    );
  }
  Future<void> addUpdateItem(ShoppingListModel shoppingModel,int index, var grocery, bool exist)async{
    await fireStoreService.addItemToShoppingList(
        shoppingModel,
        index: index,
        grocery: grocery,
        exist: exist
        );
  }
  Future<void> checkAll(ShoppingListModel shoppingListModel)async{
    List<GroceryModel> groceries = shoppingListModel.items;
    bool isUncheckedPresent = false;
    for(GroceryModel  groceryModel in groceries){
      if(groceryModel.isBought == false){
        isUncheckedPresent = true;
        groceryModel.isBought = true;
      }
    }
    if(isUncheckedPresent)
      await fireStoreService.updateShoppingList(ShoppingListModel(
        shoppingID: shoppingListModel.shoppingID,
        items: groceries
      ));
    else
      setViewState(ViewState.Idle);
  }

  void clearItems(ShoppingListModel shoopingModel,GroceryModel item) async{
    bool many = item == null;
    if(many){
      shoopingModel.items = [];
    }else{
      shoopingModel.items.removeAt(shoopingModel.items.indexOf(item));
    }
    await fireStoreService.updateShoppingList(ShoppingListModel(
      shoppingID: shoopingModel.shoppingID,
      items: shoopingModel.items
    ));
  }
}