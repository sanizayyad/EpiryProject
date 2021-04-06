import 'package:spiry/views/catalogue/productlist/catalogue.dart';
import 'package:spiry/views/others/addscreen.dart';
import 'package:spiry/views/recipe/recipemenu.dart';
import 'package:spiry/views/settings/settings.dart';
import 'package:spiry/views/shoppinglist/shoppinglist.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavItem {
  Widget screen;
  IconData iconData;
  String title;

  BottomNavItem({this.screen, this.iconData, this.title});

  static List<BottomNavItem> bottomNavList() {
    return <BottomNavItem>[
      BottomNavItem(
        title: "Catalogue",
        iconData: FontAwesomeIcons.folder,
        screen: Catalogue(),
      ),
      BottomNavItem(
        title: "Shopping",
        iconData: FontAwesomeIcons.cartPlus,
        screen: ShoppingList(),
      ),
      BottomNavItem(
        title: "Add",
        screen: AddScreen(),
      ),
      BottomNavItem(
        title: "Recipes",
        iconData: Icons.fastfood,
        screen: Recipes(),
      ),
      BottomNavItem(
        title: "Settings",
        iconData: Icons.settings,
        screen: Settings(),
      ),
    ];
    ;
  }
}
