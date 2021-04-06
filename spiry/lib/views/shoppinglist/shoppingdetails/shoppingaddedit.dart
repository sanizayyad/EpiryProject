import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/functions/selectdate.dart';
import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/signinregisterbutton.dart';
import 'package:spiry/commons/widgets/successproduct.dart';
import 'package:spiry/models/shoppinglistmodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import '../shoppinglistprovider.dart';
import 'shoppoingaddeditprovider.dart';

class ShoppingListAddEdit extends StatefulWidget {
  final arguments;
  ShoppingListAddEdit({this.arguments});
  @override
  _ShoppingListAddEditState createState() => _ShoppingListAddEditState();
}

class _ShoppingListAddEditState extends State<ShoppingListAddEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _shoppingTitle = TextEditingController();
  final TextEditingController _entryDate = TextEditingController();
  final TextEditingController _description = TextEditingController();

  ShoppingListModel _shoppingListModel;
  bool _shoppingListExists;
  bool _listIsCleared = false;
  var activeColor;

  void initializeVariables(){
    _shoppingListModel = widget.arguments[0];
    _shoppingListExists = _shoppingListModel != null;
    if (_shoppingListExists) {
      _shoppingTitle.text = _shoppingListModel.title;
      _entryDate.text = _shoppingListModel.entryDate;
      _description.text = _shoppingListModel.description;
      activeColor = _shoppingListModel.color;
    } else {
      _entryDate.text = DateFormat.yMMMd().format(DateTime.now());
      activeColor = "red";
    }
  }

  @override
  void initState() {
    initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShoppingAddEditProvider>(
      create: (BuildContext context) => ShoppingAddEditProvider(),
      child: Consumer<ShoppingAddEditProvider>(
        builder: (context, shoppingAddEditProvider, child){
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 6,
                title: Text(
                  _shoppingListExists ? "Edit Shopping list" : "Add Shopping list",
                  style: TextStyle(color: primaryColor),
                ),
                iconTheme: IconThemeData(color: primaryColor),
              ),
              body: Stack(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    controller: _shoppingTitle,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.title,size: 20,),
                                        hintText: "Enter ShoppingList title",
                                        labelText: "Title"
                                    ),
                                    validator: shoppingTitleValidator,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller:  _entryDate,
                                    onTap: () {
                                      selectDate(context,_entryDate,(){
                                        shoppingAddEditProvider.setViewState(ViewState.Idle);
                                      });
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today, size: 20),
                                        hintText: "Pick entry date",
                                        labelText: "Entry date"
                                    ),
                                    validator: entryDateValidator,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _description,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.edit, size: 20),
                                      hintText: "Enter description",
                                      labelText: "Description",
                                    ),
//                          validator: emailValidator,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.color_lens, color: Colors.grey,),
                                      SizedBox(width:10),
                                      Text("Set Color",style: TextStyle(
                                        color: greyColor,
                                        fontSize: 17,
                                      ),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceAround,
                                      children: colorGradient.map((key,value){
                                        return MapEntry(key, colorPicker(key,value));
                                      }).values.toList()
                                  )
                                ])),
                        shoppingAddEditProvider.viewState == ViewState.Busy
                            ? BusyLoading(type: 'green',)
                            : SignInRegisterButton(
                          type: "Save",
                          callBackFunction: () async {
                            var newList = ShoppingListModel(
                                title: _shoppingTitle.text,
                                shoppingID: _shoppingListModel?.shoppingID,
                                entryDate: _entryDate.text,
                                items: !_shoppingListExists || _listIsCleared ? [] : _shoppingListModel.items,
                                color: activeColor,
                                description: _description.text);
                            await shoppingAddEditProvider.saveList(_formKey, _shoppingListExists, newList);
                          },
                        ),
                        SizedBox(height: 10,),
                        _shoppingListExists ?
                        Align(
                          child: FlatButton(
                              onPressed: () {
                                locator<ShoppingListProvider>().clearItems(_shoppingListModel,null);
                                showToast("List cleared successfully", context);
                                _listIsCleared = true;
                              },
                              child: Text("Clear List",style: TextStyle(
                                  fontSize: 20,
                                  color: greyColor
                              ),)),
                        ):SizedBox()
                      ],
                    ),
                  ),
                  shoppingAddEditProvider.viewState == ViewState.Success
                      ? SuccessProduct()
                      : SizedBox()
                ],
              ));
        },
      )
    );
  }

  void changeColor(color){
    activeColor = color;
    setState(() {
    });
  }
  Widget colorPicker(mapKey,value){
    return  InkWell(
        onTap: (){
          if(mapKey != activeColor)
            changeColor(mapKey);
        },
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: mapKey == activeColor ? Border.all(color: Colors.black,width: 4) : null,
            borderRadius: BorderRadius.all(Radius.circular(60.0)),
          ),
          child:Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60.0)),
                gradient: LinearGradient(
                  colors: [value[0], value[1].withOpacity(0.7)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),

                boxShadow: [
                  BoxShadow(
                    color: value[0].withOpacity(0.4),
                    blurRadius: 4.0, // has the effect of softening the shadow
                    offset: Offset(1, 2.0),
                  )
                ],
              )
          ),
        ));
  }
}
