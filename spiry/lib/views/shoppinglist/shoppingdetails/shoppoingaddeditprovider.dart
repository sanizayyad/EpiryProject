import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/views/base/baseprovider.dart';

class ShoppingAddEditProvider extends BaseProviderModel{
  bool isDisposing;

  Future saveList(formKey, exists, ShoppingListModel shoppingListModel) async {
    try {
      if (formKey.currentState.validate()) {
        isDisposing = false;
        setViewState(ViewState.Busy);
        if(!exists)
          await fireStoreService.addShoppingList(shoppingListModel);
        else
          await fireStoreService.updateShoppingList(shoppingListModel);

        if (!isDisposing) {
          setViewState(ViewState.Success);
          await Future.delayed(Duration(milliseconds: 700));
          navigationService.pop(true);
        }
      }
    } catch (e) {
      print(e.message);
      setViewState(ViewState.Idle);
    }
  }

  void dispose(){
    isDisposing = true;
    super.dispose();
  }
}