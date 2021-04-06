import 'package:spiry/views/authentication/authentication.dart';
import 'package:spiry/views/authentication/screens/splashscreen.dart';
import 'package:spiry/views/bottomnav/bottomnav.dart';
import 'package:spiry/views/catalogue/category/category.dart';
import 'package:spiry/views/catalogue/filter/filteredproducts.dart';
import 'package:spiry/views/catalogue/filter/filtersettings.dart';
import 'package:spiry/views/catalogue/productdetails/productaddedit.dart';
import 'package:spiry/views/pantry/selectpantry.dart';
import 'package:spiry/views/shoppinglist/shoppingdetails/grocerylist.dart';
import 'package:spiry/views/shoppinglist/shoppingdetails/shoppingaddedit.dart';
import 'package:spiry/views/recipe/recipelist.dart';
import 'package:flutter/material.dart';

import 'routepaths.dart';

class Router {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return _buildRoute(settings, SplashScreen());
      case authenticationScreen:
        return _buildRoute(settings, AuthenticationScreen());
      case homeScreen:
        return _buildRoute(settings, HomeBottomNavbar());
      case productAddEdit:
        return _buildRoute(
            settings, ProductAddEdit(arguments: settings.arguments));
      case categoryAddEdit:
        return _buildRoute(settings, CategoryAddEdit());
      case filterScreen:
        return _buildRoute(
            settings, FilterScreen(arguments: settings.arguments));
      case filteredProductsScreen:
        return _buildRoute(settings, FilteredProductScreen());
      case selectPantry:
        return _buildRoute(
            settings, SelectPantry(arguments: settings.arguments));
      case shoppingAddEdit:
        return _buildRoute(
            settings, ShoppingListAddEdit(arguments: settings.arguments));
      case groceryList:
        return _buildRoute(
            settings, GroceryList(arguments: settings.arguments));
      case recipeList:
        return _buildRoute(settings, RecipeList(arguments: settings.arguments));
      default:
        return _buildRoute(
            settings,
            Scaffold(
              body: Center(
                child: Text("SCREEN NOT FOUND!"),
              ),
            ));
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget screen) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => screen,
    );
  }
}
