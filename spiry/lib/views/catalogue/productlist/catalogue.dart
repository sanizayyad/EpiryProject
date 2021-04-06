import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/tabitemcontainer.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/categorymodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/catalogue/productlist/productlist.dart';
import 'package:spiry/views/pantry/selectpantry.dart';
import 'package:spiry/views/pantry/pantryprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'catalogueprovider.dart';

class Catalogue extends StatelessWidget {

  List<Widget> tabItems(List<String> categories) {
    List<Widget> cats = categories.map((cat) => TabItemContainer(title: cat)).toList();
    cats[0] = TabItemContainer(iconData: Icons.grid_on,);
    cats[cats.length - 1] = TabItemContainer(iconData: Icons.edit,);
    return cats;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<CatalogueProvider>(
        builder: (context, catalogueProvider, child) {
      return StreamBuilder<List<CategoryModel>>(
          stream: catalogueProvider.fireStoreService.categoryStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: BusyLoading(type: 'orange',));

            List<String> catsList = catalogueProvider.mapCategoriesList(snapshot.data);
            bool selected = catalogueProvider.selectedProducts.isNotEmpty;
            return NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverSafeArea(
                        top: false,
                        sliver: SliverAppBar(
                          title: Text(selected
                              ? catalogueProvider.selectedProducts.length.toString()
                              :locator<SelectPantryProvider>().currentPantry,
                              style: TextStyle(
                              color: primaryColor,
                              fontSize: 18)),
                          leading: selected
                              ? IconButton(
                              onPressed: () {
                                catalogueProvider.emptySelected();
                              },
                              color: primaryColor,
                              icon: Icon(Icons.arrow_back))
                              :PantryLogo(),
                          actions: catalogueProvider.appbarActions(context),
                          backgroundColor: selected ? Colors.black12: Colors.white,
                          floating: true,
                          pinned: true,
                          elevation: 0,
                          snap: true,
                          bottom: PreferredSize(
                            preferredSize: Size(0, 75),
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: DefaultTabController(
                                  length: catsList.length,
                                  initialIndex: catsList.indexOf(catalogueProvider.currentCategoryFilter),
                                  child: Builder(
                                    builder: (BuildContext context){
                                      return TabBar(
                                          isScrollable: true,
                                          unselectedLabelColor: primaryColor,
                                          indicatorSize: TabBarIndicatorSize.label,
                                          indicatorWeight: 1,
                                          indicator: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: primaryColor,
                                          ),
                                          onTap: (index) {
                                            catalogueProvider.onCategoryTap(index, catsList,context);
                                          },
                                          tabs: tabItems(catsList));
                                    },
                                  ),
                                ),
                              ),
                            ), // <--,- this is required if I want the application bar to show when I scroll up
                          ),
                        ))
                  ];
                },
                body: ProductList());
          });
    });
  }
}