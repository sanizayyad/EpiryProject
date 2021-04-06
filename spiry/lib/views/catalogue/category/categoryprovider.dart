import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';



class CategoryProvider extends BaseProviderModel{
  BuildContext context;
  List<CategoryModel> categories = [];
  bool disposed;

  Future<bool> modMenu(CategoryModel categoryModel,int prodCount){
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("Edit category"),
              titlePadding:  EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        navigationService.pop(true);
                        if(categoryModel.categoryName == "uncategorized")
                          showToast("Sorry you cant edit uncategorized(default)", context);
                        else
                          addOrEditDialog(categoryModel: categoryModel);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Text( "Change category name"),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        navigationService.pop(true);
                        if(categoryModel.categoryName == "uncategorized"){
                          showToast("Sorry you cant delete uncategorized(default)", context);
                        }else{
                          deleteDialog(categoryModel,prodCount);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Text( "Delete category"),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            )
    );
  }
  Future<bool> addOrEditDialog({CategoryModel categoryModel}){
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();
    controller.text = categoryModel?.categoryName ?? "";
    disposed = false;
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("New Category Name"),
              content: Container(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: controller,
                      autofocus: true,
                      validator: categoryValidator,
                      decoration: InputDecoration(
                          labelText: "Category name",
                          labelStyle: TextStyle(
                              color: Colors.black
                          ),
                          focusColor: Colors.black,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          )
                      ),
                    ),
                  )
              ),
              titlePadding:  EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                     if(formKey.currentState.validate()){
                         navigationService.pop(true);
                         List<String> categoryNames = categories.map((e) => e.categoryName.toLowerCase()).toList();
                         var newCategory = controller.text.trim();
                         if(!categoryNames.contains(newCategory.toLowerCase())){

                           if(categoryModel != null)
                             await fireStoreService.updateCategory(categoryModel,newCategory);
                           else
                             await fireStoreService.addCategory(CategoryModel(
                                 categoryName: newCategory
                             ));

                           if(!disposed)
                             showToast("Category ${categoryModel?.categoryName != null ? "edited": "added"} successfully", context);
                         }else{
                           showToast("Category already exists", context);
                       }
                     }

                  },
                  child: Text('Confirm'),
                ),
                FlatButton(
                  onPressed: () {
                    navigationService.pop(false);
                  },
                  child: Text('Cancel'),
                ),
              ],
            )
    );
  }
  Future<bool> deleteDialog(CategoryModel categoryModel,int prodCount) {
    var addMessage = prodCount > 0 ? "$prodCount product(s) will also be deleted." :"";
    disposed = false;
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("$addMessage Would you like to continue? "),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    navigationService.pop(true);
                    try {
                        await fireStoreService.removeCategory(categoryModel);
                        if(!disposed)
                          showToast("category deleted successfully", context);
                    } catch (e) {
                      print(e.message);
                    }
                  },
                  child: Text('Yes'),
                ),
                FlatButton(
                  onPressed: () {
                    navigationService.pop(false);
                  },
                  child: Text('No'),
                ),
              ],
            )
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}