import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';
import 'package:spiry/views/pantry/pantryprovider.dart';

class FilterScreenProvider extends BaseProviderModel{
  String initialPantry;
  String pantry;
  ProductState productState;
  int viewType = 1;
  List<String> categoriesList = [];
  Map<String,bool> categoriesMap = {};
  List tickedCategories = [];

  void changeViewType(type){
    if(viewType != type){
      viewType = type;
      setViewState(ViewState.Idle);
    }
  }

  void navigateToFilter(){
    categoriesMap.forEach((key, value) {
      if(value == true)
        tickedCategories.add(key);
    });
    navigationService.pushReplacementName(filteredProductsScreen);
  }

  Future<dynamic> popChange({bool snack = false}) async{
    var pantryProv = locator<SelectPantryProvider>();
    if(initialPantry != pantryProv.currentPantry)
      await pantryProv.changePantry(initialPantry);
    if(snack)
      removeSnack(locator<CatalogueProvider>().productsContext);

    return navigationService.pushReplacementName(homeScreen);
  }

  Future<void> fetchCategories(String pantryName) async{
     pantry = pantryName;
     await locator<SelectPantryProvider>().changePantry(pantry);
     categoriesList = mapCategoriesString(await fireStoreService.getCategories());
     categoriesMap.clear();
     categoriesList.forEach((category){
      categoriesMap[category] = false;
    });
     setViewState(ViewState.Idle);

  }

  Map<int,List<ProductModel>> filter(List<ProductModel> products){
   List<ProductModel> filtered = products.where((prod) {
      ProductState state = determineState(daysLeft(prod.expiryDate));
      if(productState.color == state.color){
        if (tickedCategories.isNotEmpty) {
          for (var category in tickedCategories)
            if (category == prod.category)
              return true;
        }
        else{
          return true;
        }
      }
      return false;
    }).toList();
   return locator<CatalogueProvider>().sortDaysLeft(filtered);
  }
}
