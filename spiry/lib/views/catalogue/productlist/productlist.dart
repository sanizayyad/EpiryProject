import 'package:cached_network_image/cached_network_image.dart';
import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/datetag.dart';
import 'package:spiry/commons/widgets/emptycatalogue.dart';
import 'package:spiry/commons/widgets/swipetodismiss.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/catalogue/filter/filterprovider.dart';
import 'package:spiry/views/catalogue/productdetails/productaddeditprovider.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'catalogueprovider.dart';


class ProductList extends StatelessWidget {
  final filterScreen;
  ProductList({this.filterScreen = false});

  @override
  Widget build(BuildContext context) {
    var catalogueProvider = locator<CatalogueProvider>();

    return StreamBuilder<List<ProductModel>>(
              stream: catalogueProvider.fireStoreService.productStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: BusyLoading(type: 'orange',));

                catalogueProvider.productsContext = context;
                Map<int,List<ProductModel>> daysLeftSorted;
                bool type;
                if(!filterScreen){
                  var filtered = catalogueProvider.filterProducts(snapshot.data);
                  daysLeftSorted = catalogueProvider.sortDaysLeft(filtered);
                  type = catalogueProvider.viewTypeList;
                }else{
                  daysLeftSorted = locator<FilterScreenProvider>().filter(snapshot.data);
                  type = locator<FilterScreenProvider>().viewType == 1 ? true: false;
                }

                return  daysLeftSorted.length == 0
                    ? EmptyCatalogueState()
                    : BuildList(daysLeftSorted: daysLeftSorted,viewTypeList:type,filterScreen: filterScreen,);
              });
  }
}


class BuildList extends StatelessWidget {
  final Map<int,List<ProductModel>> daysLeftSorted;
  final bool viewTypeList;
  final filterScreen;
  BuildList({this.daysLeftSorted,this.viewTypeList,this.filterScreen});

  @override
  Widget build(BuildContext context) {
    var catalogueProvider = locator<CatalogueProvider>();
    return Container(
      color: greyBg,
      child: ListView(
        padding: EdgeInsets.only(bottom: 10),
        shrinkWrap: true,
        children: daysLeftSorted.map((keys, values) {
          var prodState = determineState(keys);
          return MapEntry(keys, Column(
              children: <Widget>[
               Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.brightness_1,
                          color: prodState.color, size: 16),
                      SizedBox(width: 15),
                      Text(
                        '${prodState.state}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      !catalogueProvider.selectedProducts.isNotEmpty
                          ? IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            ProductAddEditProvider().deleteDialog(context, daysLeftSorted[keys], false);
                          })
                          : Container(),
                      catalogueProvider.selectedProducts.isNotEmpty
                          ? Container(
                        margin: EdgeInsets.only(left: 10,bottom: 12,top: 12),
                        child: GestureDetector(
                          onTap: (){
                            if(catalogueProvider.checkSubList(daysLeftSorted[keys])){
                              catalogueProvider.removeSubList(daysLeftSorted[keys]);
                            }else{
                              catalogueProvider.addSubList(daysLeftSorted[keys]);
                            }
                          },
                          child: Icon(
                            Icons.check_circle,
                            color: catalogueProvider.checkSubList(daysLeftSorted[keys])
                                ? Colors.green
                                : Colors.grey,),
                        ),
                      )
                          :Container()
                    ],
                  ),
                ),
                !viewTypeList
                    ? Container(
                  color: Colors.white,
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shrinkWrap: true,
                    primary: false,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1,
                    children: daysLeftSorted[keys].map((prod) => GridItem(productModel: prod,filterScreen: filterScreen,)).toList(),
                  ),
                )
                    : ListView(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.all(0),
                  children: daysLeftSorted[keys].map((prod){
                    return catalogueProvider.selectedProducts.isEmpty ? SwipeToDismiss(
                      secondary: true,
                      func: (direction){
                        catalogueProvider.dismissed(direction,daysLeftSorted[keys][values.indexOf(prod)]);
                      },
                      child:  ListItem(productModel: prod,filterScreen: filterScreen,),
                    ): ListItem(productModel: prod,filterScreen: filterScreen,);
                  }).toList(),
                )
              ]));}).values.toList(),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final productModel;
  final bool filterScreen;
  GridItem({this.productModel, this.filterScreen});
  @override
  Widget build(BuildContext context) {
    var catalogoueProvider = locator<CatalogueProvider>();
    return InkWell(
      onTap: () {
       catalogoueProvider.onProductTap(productModel);
      },
      onLongPress: (){
        if(!filterScreen)
          catalogoueProvider.select(productModel);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Expanded(
               child: Container(
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: productModel.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context,url)=>Image.asset("images/imageloading.gif"),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Positioned(
                        top: 6,
                        left: 4,
                        right: 4,
                        child: DateTag(
                          expiryDate: productModel.expiryDate,
                          category: productModel.category,
                          whiteOnblack: true,
                        ),
                      ),
                      catalogoueProvider.selectedProducts.contains(productModel) ?
                      Align(
                        alignment: Alignment.center,
                          child: Stack(
                            children: <Widget>[
                              Center(child: Container(color: Colors.white,height: 25,width: 30,)),
                              Center(child: Icon(Icons.check_circle,color: Colors.green,size: 50,)),
                            ],
                          ))
                          :Container()
                    ],
                  ),
                ),
             ),
            SizedBox(height: 5,),
            Text(
              productModel.productName,
              style: TextStyle(
                color: primaryColor,
                fontSize: 19,
                fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              productModel.description,
              style: TextStyle(
                color: primaryColor.withOpacity(0.6),
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget                                                                                                                                                    {
  final ProductModel productModel;
  final bool filterScreen;
  ListItem({this.productModel,this.filterScreen});
  @override
  Widget build(BuildContext context) {
    var catalogoueProvider = locator<CatalogueProvider>();
    return InkWell(
      onTap: () {
        catalogoueProvider.onProductTap(productModel);
      },
      onLongPress: (){
        if(!filterScreen)
          catalogoueProvider.select(productModel);
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
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                            imageUrl: productModel.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context,url)=>Image.asset("images/imageloading.gif"),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        catalogoueProvider.selectedProducts.contains(productModel) ?
                        Align(
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                Center(child: Container(color: Colors.white,height: 25,width: 30,)),
                                Center(child: Icon(Icons.check_circle,color: Colors.green,size: 50,)),
                              ],
                            ))
                            :Container()
                      ],
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
                        expiryDate: productModel.expiryDate,
                        category: productModel.category,
                        whiteOnblack: false,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        productModel.productName,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        productModel.description,
                        style: TextStyle(
                          color: primaryColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

