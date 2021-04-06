import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'categoryprovider.dart';



class CategoryAddEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<CategoryProvider>(
        create: (BuildContext context) => CategoryProvider(),
        child: Consumer<CategoryProvider>(
            builder: (_,categoryProvider,child){
              categoryProvider.context = context;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  title: Text("Category modification",
                    style: TextStyle(color: primaryColor),
                  ),
                  iconTheme: IconThemeData(color: primaryColor),
                ),
                floatingActionButton:FloatingActionButton(
                  elevation: 9,
                  backgroundColor: primaryColor,
                  onPressed: () async{
                    await categoryProvider.addOrEditDialog();
                  },
                  child: Icon(Icons.add,),
                ),
                body: Container(
                  child: StreamBuilder<List<CategoryModel>>(
                      stream: categoryProvider.fireStoreService.categoryStream(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                        var categories = snapshot.data;
                        categoryProvider.categories = categories;
                        return StreamBuilder<List<ProductModel>>(
                          stream: categoryProvider.fireStoreService.productStream(),
                            builder: (context,snapshot){
                            if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);

                            return  ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (context,index){
                                  var filterProd = snapshot.data.where((item)=> item.category == categories[index].categoryName).toList() ?? [];
                                  var prodCount = filterProd.length;
                                  return Card(
                                      elevation: 1,
                                      margin: EdgeInsets.fromLTRB(0,0,0,2),
                                      child: Container(
                                        height: 70,
                                        child: Center(
                                          child: ListTile(
                                            title: Text("${categories[index].categoryName} ($prodCount)"),
                                            contentPadding: EdgeInsets.only(left: 22,right: 14),
                                            trailing: Icon(Icons.menu),
                                            onTap: (){
                                              categoryProvider.modMenu(categories[index],prodCount);
                                            },
                                          ),
                                        ),)
                                  );
                                }
                            );
                            });
                      }

                  ),
                ),
              );
            }),
    );}
}