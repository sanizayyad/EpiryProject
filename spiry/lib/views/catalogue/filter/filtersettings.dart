import 'package:spiry/commons/functions/dropdown.dart';
import 'package:spiry/commons/widgets/labeledRadio.dart';
import 'package:spiry/commons/widgets/signinregisterbutton.dart';
import 'package:spiry/models/productmodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import 'filterprovider.dart';

class FilterScreen extends StatefulWidget {
  final arguments;
  FilterScreen({this.arguments});
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final GlobalKey _dropdownButtonKey = GlobalKey();
  List<ProductState> _productStates;
  List _pantries;

  @override
  void initState() {
    locator.resetLazySingleton<FilterScreenProvider>();
    initializeVariables();
    super.initState();
  }
  void initializeVariables(){
    _productStates = ProductState.productStates();
    var filterProv = locator<FilterScreenProvider>();
    filterProv.productState = _productStates[0];
    _pantries = widget.arguments[0];
    filterProv.initialPantry = widget.arguments[1];
    filterProv.fetchCategories(filterProv.initialPantry);
  }

  Widget checkBox(title,boolValue,_categories){
    return InkWell(
      onTap: (){
        setState(() {
          _categories[title] = !boolValue;
        });
      },
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 37,
            height: 37,
            child: Checkbox(
              activeColor: orangeColor,
              value: boolValue,
              onChanged: (bool value) {
                setState(() {
                  _categories[title] = value;
                });
              },
            ),
          ),
          SizedBox(width: 20,),
          Text(title,style: TextStyle(
              fontSize: 16
          ),)
        ],
      ),
    );
  }
  Widget radioButton(state){
    return LabeledRadio(
      label: Text(
        "${state.state}",
        style: TextStyle(fontSize: 16),
      ),
      value: _productStates.indexOf(state),
      groupValue: _productStates.indexOf(locator<FilterScreenProvider>().productState),
      activeColor: locator<FilterScreenProvider>().productState.color,
      onChanged: (newValue) {
        setState(() {
          locator<FilterScreenProvider>().productState = _productStates[newValue];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<FilterScreenProvider>(
        create: (BuildContext context) => locator<FilterScreenProvider>(),
      child: Consumer<FilterScreenProvider>(
          builder: (context, filterProvider, child) => WillPopScope(
            onWillPop: () async =>  await filterProvider.popChange(),
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
                    return [
                      SliverAppBar(
                        title: Text(
                          "Filter products",
                          style: TextStyle(color: primaryColor, fontSize: 22),
                        ),
                        floating: true,
                        snap: true,
                        pinned: false,
                        leading: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.times,
                            color: orangeColor,
                          ),
                          onPressed: ()async => await filterProvider.popChange(),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      )
                    ];
                  },
                  body: Stack(
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.all(0),
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          CardItem(
                            widget: Row(
                              children: <Widget>[
                                Text(
                                  "Layout view",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                ),
                                Spacer(),
                                IconButton(
                                    icon: Icon(FontAwesomeIcons.listAlt),
                                    color: filterProvider.viewType == 1 ? orangeColor : null,
                                    onPressed: () {
                                      filterProvider.changeViewType(1);
                                    }),
                                IconButton(
                                    icon: Icon(FontAwesomeIcons.gripVertical),
                                    color: filterProvider.viewType != 1 ? orangeColor : null,
                                    onPressed: () {
                                      filterProvider.changeViewType(2);
                                    }),
                              ],
                            ),
                          ),
                          CardItem(
                            title: "Pantry",
                            widget: GestureDetector(
                              onTap: () {
                                openDropdown(_dropdownButtonKey);
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  hintText: 'Pantry',
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child: DropdownButton<String>(
                                          key: _dropdownButtonKey,
                                          value:filterProvider.pantry,
                                          isDense: true,
                                          isExpanded: true,
                                          icon: Icon(null),
                                          onChanged: (String newValue) async{
                                            await filterProvider.fetchCategories(newValue);
                                          },
                                          items: _pantries.map((value) {
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
                          ),
                          CardItem(
                            title: "Categories",
                            widget: Column(
                              children:  filterProvider.categoriesMap.map((key,value){
                                return MapEntry(key, checkBox(key, filterProvider.categoriesMap[key], filterProvider.categoriesMap));
                              }).values.toList(),
                            ),
                          ),
                          CardItem(
                            title: "Product state",
                            widget: Column(
                                children: _productStates.map((state)=>radioButton(state)).toList()
                            ),
                          ),
                          SizedBox(
                            height: 150,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 40),
                          child: SignInRegisterButton(
                            type: 'FILTER',
                            callBackFunction: (){
                              filterProvider.navigateToFilter();
                            },
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          )),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final widget;
  CardItem({this.title,this.widget});
  @override
  Widget build(BuildContext context) {
    bool titleExist = title != null;
    return Card(
      margin: EdgeInsets.only(bottom: 14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            titleExist ? Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.grey),
            ):SizedBox(),
            titleExist ? SizedBox(height: 14,) : SizedBox(),
            Container(
              padding: titleExist ? EdgeInsets.only(left: 10) : EdgeInsets.only(left: 0),
              child: widget,
            )
          ],
        ),
      ),
    );
  }
}

