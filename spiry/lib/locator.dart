
import 'package:get_it/get_it.dart';
import 'package:spiry/services/recipe/abstract.dart';
import 'package:spiry/services/recipe/recipeservice.dart';
import 'package:spiry/views/recipe/recipeprovider.dart';

import 'services/Notification/localpushnotification.dart';
import 'services/Notification/pushnotification.dart';
import 'services/deeplink/dynamiclink.dart';
import 'services/firebase/abstracts/authenticationservice.dart';
import 'services/firebase/abstracts/databaseservice.dart';
import 'services/firebase/remotedata/firebaseauthentication.dart';
import 'services/firebase/remotedata/firestoredatabase.dart';
import 'services/navigation/navigationservice.dart';
import 'views/authentication/authenticationprovider.dart';
import 'views/bottomnav/bottomnavprovider.dart';
import 'views/catalogue/filter/filterprovider.dart';
import 'views/catalogue/productlist/catalogueprovider.dart';
import 'views/pantry/pantryprovider.dart';
import 'views/settings/settingsprovider.dart';
import 'views/shoppinglist/shoppinglistprovider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //register services
  locator.registerLazySingleton<AuthenticationService>(()=>FirebaseAuthenticationService());
  locator.registerLazySingleton<DatabaseService>(()=>FireStoreService());
  locator.registerLazySingleton<AbstractRecipe>(()=>RecipeService());
  locator.registerLazySingleton<NavigationService>(()=>NavigationService());
  locator.registerLazySingleton<PushNotificationService>(()=>PushNotificationService());
  locator.registerLazySingleton<LocalPushNotificationService>(()=>LocalPushNotificationService());
  locator.registerLazySingleton<DynamicLinkService>(()=>DynamicLinkService());

  //register providers
  locator.registerLazySingleton<AuthenticationProvider>(()=>AuthenticationProvider());//
  locator.registerLazySingleton<BottomNavBarProvider>(()=>BottomNavBarProvider());
  locator.registerLazySingleton<SelectPantryProvider>(()=>SelectPantryProvider());
  locator.registerLazySingleton<CatalogueProvider>(()=>CatalogueProvider());
  locator.registerLazySingleton<FilterScreenProvider>(()=>FilterScreenProvider());
  locator.registerLazySingleton<ShoppingListProvider>(()=>ShoppingListProvider());
  locator.registerLazySingleton<RecipeProvider>(()=>RecipeProvider());
  locator.registerLazySingleton<SettingsProvider>(()=>SettingsProvider());



}