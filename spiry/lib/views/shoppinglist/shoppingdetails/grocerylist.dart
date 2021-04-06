import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/emptycatalogue.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';

import '../shoppinglistprovider.dart';

class GroceryList extends StatelessWidget {
  final arguments;
  GroceryList({this.arguments});

  @override
  Widget build(BuildContext context) {
    var shoppingId = arguments[0];
    ShoppingListProvider shoppingProvider = locator<ShoppingListProvider>();
    return StreamBuilder<ShoppingListModel>(
        stream:shoppingProvider.fireStoreService.currentShoppingDocumentStream(shoppingId),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Center(child: BusyLoading(type: 'orange',));
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 6,
              title: Text(
                snapshot.data.title,
                style: TextStyle(color: primaryColor),
              ),
              iconTheme: IconThemeData(color: primaryColor),
              actions: <Widget>[
                IconButton(
                    icon: ImageIcon(AssetImage('images/edit.png')),
                    iconSize: 20,
                    color: primaryColor,
                    onPressed: () async {
                      await shoppingProvider.addOrEditNavigation(snapshot.data);
                    }),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await shoppingProvider.deleteListDialog(context, snapshot.data);
                    }),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 9,
              backgroundColor: primaryColor,
              onPressed: () async {
                await shoppingProvider.addOrEditItemDialog(context,snapshot.data,null);
              },
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.white,
            body: snapshot.data.items.length == 0
                ? EmptyCatalogueState()
                : DataTableIm(model: snapshot.data,),
          );
        });
  }
}

class DataTableIm extends StatelessWidget {
  final ShoppingListModel model;
  DataTableIm({this.model});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0,16,0,100),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: colorGradient[model.color][0]
        ),
        child: DataTable(
          columnSpacing: 10,
            columns: [
              DataColumn(
                label: Text(
                'Products',
                style: TextStyle(
                  fontSize: 17,
                    color: colorGradient[model.color][0]
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              numeric: false,

              ),
              DataColumn(
                label: Container(
                  width: 50,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontSize: 17,
                        color: colorGradient[model.color][0]
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                numeric: false,
              ),
              DataColumn(
                label: Container(),
                numeric: false,
              )
            ],
            rows: model.items.map((item) =>DataRow(
                      selected: item.isBought,
                      onSelectChanged: (value) {
                        item.isBought = value;
                        int index = model.items.indexOf(item);
                        locator<ShoppingListProvider>().addUpdateItem(model, index,item, true);
                      },
                      cells: [
                        DataCell(
                          Container(
                            width: MediaQuery.of(context).size.width - 200,
                            margin: EdgeInsets.only(right: 5),
                            child: Text(
                              "${item.groceryName}",
                              style: TextStyle(
                                fontSize: 17,
                                decoration: item.isBought ? TextDecoration.lineThrough : null,
                                color: item.isBought ? greyColor : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 50,
                            child: Text(
                              "${item.quantity}",
                              style: TextStyle(
                                fontSize: 17,
                                color: item.isBought ? greyColor : null,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 20,
                            child: Icon(Icons.edit,size: 20,),
                          ),
                          onTap: (){
                            locator<ShoppingListProvider>().addOrEditItemDialog(context, model, item);
                          },
                        ),
                      ])
            ).toList(),
        ),
      ),
    );
  }
}