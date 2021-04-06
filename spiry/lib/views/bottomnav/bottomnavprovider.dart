import 'dart:async';

import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/bottomnavitem.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';
import 'package:spiry/views/shoppinglist/shoppinglistprovider.dart';
import 'package:flutter/material.dart';

class BottomNavBarProvider extends BaseProviderModel{
  List<BottomNavItem> screensInfo = BottomNavItem.bottomNavList();
  List<Widget> pages = [Container(),Container(),Container(),Container(),Container()];
  List<int> firstBuild = [];
  int screenIndex;
  StreamController<int> indexStreamController = StreamController<int>();
  AnimationController translateAnimationController;
  bool _forward = false;


  void removeSnacks(){
    try{
      removeSnack(locator<CatalogueProvider>().productsContext);
      removeSnack(locator<ShoppingListProvider>().shopListContext);
    }catch (e){
    }
  }
  void changeScreen(index){
    if (index != screenIndex) {
      removeSnacks();
      if(!firstBuild.contains(index)){
        pages.removeAt(index);
        pages.insert(index, BottomNavItem.bottomNavList()[index].screen);
        firstBuild.add(index);
      }
      screenIndex = index;
      indexStreamController.add(screenIndex);
      setViewState(ViewState.Idle);
      if(index == 1)
        locator<ShoppingListProvider>().setViewState(ViewState.Idle);
    }
  }

  void animTap(page) {
    if(_forward){
      translateAnimationController.reverse();
      _forward = false;
      changeScreen(page);
    }
    else{
      translateAnimationController.forward();
      _forward = true;
      changeScreen(2);
    }

  }

}