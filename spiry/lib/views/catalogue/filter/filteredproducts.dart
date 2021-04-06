import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';
import 'package:spiry/views/catalogue/productlist/productlist.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import 'filterprovider.dart';

class FilteredProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
                onWillPop: () async {
                  return await locator<FilterScreenProvider>().popChange(snack: true);
                },
                child: Scaffold(
                    appBar: AppBar(
                      title: Text("Filtered Products",
                          style: TextStyle(color: primaryColor, fontSize: 18)),
                      leading: IconButton(
                          onPressed: () async {
                            await locator<FilterScreenProvider>().popChange(snack: true);
                          },
                          icon: Icon(Icons.arrow_back),
                          color: primaryColor),
                      actions: <Widget> [
                        IconButton(
                          onPressed: () {
                            locator<CatalogueProvider>().navigateToFilter();
                          },
                          icon: ImageIcon(AssetImage('images/filter.png'),
                              size: 24, color: primaryColor),
                        ),
                        SizedBox(width: 16)
                      ],
                      backgroundColor: Colors.white,
                      elevation: 1,
                    ),
                    backgroundColor: greyBg,
                    body: ProductList(filterScreen: true,))
    );
  }
}
