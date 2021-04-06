import 'package:spiry/views/bottomnav/cutsombottomnav.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';
import 'package:spiry/views/settings/settingsprovider.dart';
import 'package:spiry/views/shoppinglist/shoppinglistprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'bottomnavprovider.dart';


class HomeBottomNavbar extends StatefulWidget {
  @override
  _HomeBottomNavbarState createState() => _HomeBottomNavbarState();
}

class _HomeBottomNavbarState extends State<HomeBottomNavbar> {
  @override
  void initState() {
    locator<BottomNavBarProvider>().changeScreen(0);
    super.initState();
  }

//  @override
  void dispose() {
    locator.resetLazySingleton<BottomNavBarProvider>();
    locator.resetLazySingleton<CatalogueProvider>();
    locator.resetLazySingleton<ShoppingListProvider>();
    locator.resetLazySingleton<SettingsProvider>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CatalogueProvider>(
            create: (BuildContext context) => locator<CatalogueProvider>()),
        ChangeNotifierProvider<ShoppingListProvider>(
            create: (BuildContext context) => locator<ShoppingListProvider>()),
        ChangeNotifierProvider<SettingsProvider>(
            create: (BuildContext context) => locator<SettingsProvider>()),
        ChangeNotifierProvider<BottomNavBarProvider>(
            create: (BuildContext context) => locator<BottomNavBarProvider>())
      ],
      child: Consumer<BottomNavBarProvider>(
        builder: (_, bottomNavProvider, child) => Scaffold(
          bottomNavigationBar: CustomBottomNav(),
          body: IndexedStack(
              index: bottomNavProvider.screenIndex,
              children: bottomNavProvider.pages),
        ),
      ),
    );
  }
}
