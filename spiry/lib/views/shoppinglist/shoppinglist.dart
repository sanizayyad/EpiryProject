 import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/widgets/Progress.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/emptycatalogue.dart';
import 'package:spiry/commons/widgets/swipetodismiss.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/pantry/selectpantry.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'shoppinglistprovider.dart';

class ShoppingList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListProvider>(
        builder: (context, shoppingProvider, child) {
      return StreamBuilder<List<ShoppingListModel>>(
          stream: shoppingProvider.fireStoreService.shoppingStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: BusyLoading(type: 'orange',));

            shoppingProvider.shopListContext = context;
            bool listIsEmpty = snapshot.data.length == 0;
            sortShoppingList(snapshot.data, shoppingProvider.order);

            return Scaffold(
                backgroundColor: Colors.white,
                body: NestedScrollView(headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        title: Text(
                          "Shopping List",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        floating: true,
                        snap: true,
                        pinned: false,
                        leading: PantryLogo(),
                        backgroundColor: Colors.white,
                        actions: <Widget>[
                          IgnorePointer(
                            ignoring: listIsEmpty,
                            child: SizedBox(
                              child: IconButton(
                                  icon: Icon(shoppingProvider.order ? FontAwesomeIcons.sortNumericDown: FontAwesomeIcons.sortNumericUp,
                                    color: listIsEmpty ? greyColor: primaryColor,),
                                  onPressed: () {
                                    shoppingProvider.changeOrder();
                                  }
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                    )
                  ];
                },
                    body: listIsEmpty
                        ?  EmptyCatalogueState()
                        : ListView(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  children: snapshot.data.map((item) {
                    return SwipeToDismiss(
                      secondary: true,
                      margin: true,
                      func: (direction){
                        shoppingProvider.dismissed(direction, item);
                      },
                      child: CardItem(model: item,
                        gradientColor: colorGradient[item.color],
                        ctx: context,),
                    );
                  }).toList(),
                )
                )
            );
          });
    });
  }
}

class CardItem extends StatelessWidget {
  final ShoppingListModel model;
  final List<Color> gradientColor;
  final ctx;
  CardItem({this.model,this.gradientColor,this.ctx});

  @override
  Widget build(BuildContext context) {
    List date = model.entryDate.replaceAll(',', ' ').split(' ');
    var itemsLenght = model.items.length;
    var itemsLenghtFormat = itemsLenght.toString().length == 1 ? "0$itemsLenght" : itemsLenght;

    var done = model.items.where((item)=>item.isBought == true).toList().length;
    bool completed = done == itemsLenght && itemsLenght != 0;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 16,),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text("${date[1]}\n${date[0]}", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
              textAlign: TextAlign.center,),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: InkWell(
              splashColor: gradientColor[0],
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              onTap: (){
                   final shopPro = locator<ShoppingListProvider>();
                  shopPro.navigationService.pushNamed(groceryList, arguments: [model.shoppingID]).then((value){
                    shopPro.setViewState(ViewState.Idle);
                  });
                  removeSnack(ctx);
              },
              child: Container(
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  gradient: LinearGradient(
                    colors: [gradientColor[0], gradientColor[1].withOpacity(0.7)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:gradientColor[0].withOpacity(0.4),
                      blurRadius: 4.0, // has the effect of softening the shadow
                      offset: Offset(1, 2.0),
                    )
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: -25,
                      right: -35,
                      child: Transform.rotate(
                          angle: -0.456332,
                          child: Icon(FontAwesomeIcons.clipboardList,size: 125, color: Colors.white.withOpacity(.25),)),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(itemsLenght == 0 ? "Empty!"
                            :"$done / $itemsLenghtFormat item(s)", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: completed ? TextDecoration.lineThrough:null,
                            fontSize: 16,
                          ),),
                          SizedBox(height: 15,),
                          Text(model.title, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 28,
                            decoration: completed ? TextDecoration.lineThrough:null,
                          ),maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10,),
                          Text(model.description, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10,),
                          model.items.length != 0 ?
                          SizedBox(
                            height: 15,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Progress(value: done/itemsLenght,color: colorGradient[model.color][1])
                                ),
                                SizedBox(width: 15),
                                Text("${(done/itemsLenght * 100).round()}%", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),),
                              ],
                            ),
                          ) :SizedBox()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
        ],
      ),
    );
  }
}