import 'package:spiry/commons/functions/dropdown.dart';
import 'package:spiry/commons/functions/generatebarcode.dart';
import 'package:spiry/commons/functions/selectdate.dart';
import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/imageselector.dart';
import 'package:spiry/commons/widgets/signinregisterbutton.dart';
import 'package:spiry/commons/widgets/successproduct.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/utilities/consttexts.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/catalogue/productlist/catalogueprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../locator.dart';
import 'productaddeditprovider.dart';


class ProductAddEdit extends StatefulWidget {
  final arguments;
  ProductAddEdit({this.arguments});

  @override
  _ProductAddEditState createState() => _ProductAddEditState();
}

class _ProductAddEditState extends State<ProductAddEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _dropdownButtonKey = GlobalKey();

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _entryDate = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController();
  final TextEditingController _description = TextEditingController();

  ProductModel _productModel;
  List _spinnerItem;
  var _initialCategory;
  bool _productExist;
  var barcode = "";

  @override
  void initState() {
    super.initState();
    initializeVariables();
  }

  @override
  void dispose() {
    _productName.dispose();
    _entryDate.dispose();
    _expiryDate.dispose();
    _description.dispose();
    super.dispose();
  }

  void initializeVariables(){
    _productModel = widget.arguments[0];
    _spinnerItem = widget.arguments[1];
    _productExist = _productModel != null;
    if (_productExist) {
      _productName.text = _productModel.productName;
      _entryDate.text = _productModel.entryDate;
      _expiryDate.text = _productModel.expiryDate;
      _description.text = _productModel.description;
      _initialCategory = _productModel.category;
      barcode = _productModel.barcode;
    } else {
      var filter = locator<CatalogueProvider>().currentCategoryFilter;
      var currentFilter = filter == "All Products" ? _spinnerItem[0] : filter;
      _initialCategory = _spinnerItem.firstWhere((item) => item == currentFilter);
      _entryDate.text = DateFormat.yMMMd().format(DateTime.now());
      generateBarcode().then((value){
        barcode = value;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductAddEditProvider>(
        create: (BuildContext context) => ProductAddEditProvider(),
      child: Consumer<ProductAddEditProvider>(
          builder: (context, productAddEditProvider, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 2,
                title: Text(
                  _productExist ? "Edit Product":"Add Product",
                  style: TextStyle(color: primaryColor),
                ),
                iconTheme: IconThemeData(color: primaryColor),
                actions: <Widget>[
                  _productExist ? IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      color: Colors.green,
                      onPressed: () async {
                        var catalogueProvider = locator<CatalogueProvider>();
                        await catalogueProvider.addSelectedShoppingList(context,[_productModel]);
                        catalogueProvider.emptySelected();
                      }): SizedBox(),
                  _productExist ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await productAddEditProvider.deleteDialog(context, _productModel, true);
                      }): SizedBox(),
                ],
              ),
              backgroundColor: greyBg,
              body: Stack(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: ImageSelector(
                                  productImage: _productExist ? _productModel.imageUrl : defaultImageUrl,
                                  provider: productAddEditProvider,
                                  height: 90,
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20, top: 8),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              selectDate(context,_expiryDate,(){
                                                productAddEditProvider.setViewState(ViewState.Idle);
                                              });
                                            },
                                            child: Text(
                                              _entryDate.text,
                                              style: TextStyle(
                                                color: primaryColor.withOpacity(0.6),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          BarcodeTag(
                                              barcode: barcode)
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _productName,
                                        decoration: InputDecoration(
                                            hintText: "Enter product name",
                                            labelText: "Product name"
                                        ),
                                        validator: productNameValidator,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            color: Colors.white,
                            child: Column(children: <Widget>[
                              TextFormField(
                                controller: _expiryDate,
                                onTap: () {
                                  selectDate(context,_expiryDate,(){
                                    productAddEditProvider.setViewState(ViewState.Idle);
                                  });
                                },
                                decoration: InputDecoration(
                                    icon: ImageIcon(AssetImage('images/calendar.png')),
                                    hintText: "Expiry date",
                                    labelText: "Expiry date"

                                ),
                                validator: expiryDateValidator,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  openDropdown(_dropdownButtonKey);
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                      icon: ImageIcon(AssetImage('images/category.png')),
                                      hintText: 'Category',
                                      labelText: "Category"

                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: DropdownButton<String>(
                                            key: _dropdownButtonKey,
                                            value: _initialCategory,
                                            isDense: true,
                                            isExpanded: true,
                                            icon: Icon(null),
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _initialCategory = newValue;
                                              });
                                            },
                                            items: _spinnerItem.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _description,
                                maxLines: 2,
                                decoration: InputDecoration(
                                    icon: ImageIcon(AssetImage('images/edit.png')),
                                    hintText: "Enter description",
                                    labelText: "Description"
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ])),
                        SizedBox(
                          height: 20,
                        ),
                        productAddEditProvider.viewState == ViewState.Busy
                            ? BusyLoading(type: 'green',)
                            : SignInRegisterButton(
                          type: "Save",
                          callBackFunction: () async {
                            var newProduct  = ProductModel(
                                productName: _productName.text,
                                productID: _productModel?.productID,
                                imageUrl: _productExist
                                    ? _productModel.imageUrl
                                    : defaultImageUrl,
                                category: _initialCategory,
                                barcode: barcode,
                                entryDate: _entryDate.text,
                                expiryDate: _expiryDate.text,
                                description: _description.text != ""
                                    ? _description.text
                                    : "No description for this product");
                            await productAddEditProvider.saveProduct(_formKey, _productExist, newProduct);
                          },
                        ),
                      ],
                    ),
                  ),
                  productAddEditProvider.viewState == ViewState.Success
                      ? SuccessProduct()
                      : SizedBox()
                ],
              ),
            );
          }),
    );
  }
}


class BarcodeTag extends StatelessWidget {
  final barcode;

  BarcodeTag({this.barcode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(
          barcode,
          style: TextStyle(
            color: primaryColor.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
