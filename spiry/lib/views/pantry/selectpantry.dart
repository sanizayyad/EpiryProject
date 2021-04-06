import 'package:spiry/commons/widgets/datetag.dart';
import 'package:spiry/commons/widgets/labeledRadio.dart';
import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/pantry.dart';
import 'package:spiry/models/usermodel.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/pantry/pantryprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectPantry extends StatefulWidget {
  final arguments;

  SelectPantry({this.arguments});

  @override
  _SelectPantryState createState() => _SelectPantryState();
}

class _SelectPantryState extends State<SelectPantry> {
  @override
  void initState() {
    super.initState();
//    locator<SelectPantryProvider>().isCurrentRoute = true;
//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      if (widget.arguments != null) {
////        await locator<SelectPantryProvider>().acceptPantryDialog(widget.arguments[0]);
//      }
//    });
  }

  @override
  void dispose() {
//    locator<SelectPantryProvider>().isCurrentRoute = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectPantryProvider>(
      create: (BuildContext context) => locator<SelectPantryProvider>(),
      child: Consumer<SelectPantryProvider>(
          builder: (context, pantryProvider, child) {
        pantryProvider.context = context;
        return WillPopScope(
          onWillPop: () async => pantryProvider.navigationService.pushReplacementName(homeScreen),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Select Pantry',
                style: TextStyle(color: primaryColor),
              ),
              elevation: 1,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    pantryProvider.navigationService.pushReplacementName(homeScreen);
                  }),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 9,
              backgroundColor: primaryColor,
              onPressed: () {
                pantryProvider.addPantryDialog();
              },
              child: Icon(
                Icons.add,
              ),
            ),
            backgroundColor: greyBg,
            body: StreamBuilder<UserModel>(
                stream: pantryProvider.fireStoreService.userStream(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData)
                    return Center(child: BusyLoading(type: 'orange',),);
                  pantryProvider.userModel = snapshot.data;
                  pantryProvider.getPantries(snapshot.data);
                  return pantryProvider.viewState == ViewState.Busy
                      ? Center(
                          child: BusyLoading(
                          type: 'orange',
                        ))
                      : ListView(
                          children: pantryProvider.pantries
                              .map((pantry) => PantryInfos(
                                    pantryModel: pantry,
                                    username: snapshot.data.username,
                                  ))
                              .toList(),
                        );
                }),
          ),
        );
      }),
    );
  }
}

class PantryInfos extends StatelessWidget {
  final username;
  final PantryModel pantryModel;

  PantryInfos({this.username, this.pantryModel});

  Widget info(String info, String value) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            info,
            style: TextStyle(color: greyColor.withOpacity(0.7), fontSize: 14),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            value,
            style: TextStyle(
                color: primaryColor, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var pantryProvider = locator<SelectPantryProvider>();
    return InkWell(
      onTap: () {
        pantryProvider.changePantry(pantryModel.pantryName);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: pantryProvider.currentPantry == pantryModel.pantryName
                    ? Colors.blue
                    : Colors.white,
                width: 2.5),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                LabeledRadio(
                  label: Text(
                    "${pantryModel.pantryName}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subLabel: Text(
                    "${pantryModel.dateCreated}",
                    style: TextStyle(
                        fontSize: 11, color: greyColor.withOpacity(0.8)),
                  ),
                  groupValue: pantryProvider.currentPantry,
                  value: pantryModel.pantryName,
                  onChanged: (newValue) {
                    pantryProvider.changePantry(newValue);
                  },
                ),
                Flexible(
                  child: DateTag(
                    expiryDate: "",
                    category: "\t\t\t${pantryModel.members[username]}\t\t\t",
                    whiteOnblack: false,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                IgnorePointer(
                  ignoring:
                      pantryModel.numberOfCategories == "0" ? true : false,
                  child: PopupMenuButton(
                    child: Container(
                        child: Icon(
                      Icons.more_vert,
                      color: primaryColor,
                    )),
                    itemBuilder: (context) => <PopupMenuItem>[
//                      PopupMenuItem(
//                        child: Text("Share Pantry"),
//                        value: 0,
//                      ),
                      PopupMenuItem(
                        child: Text("Delete Pantry"),
                        value: 0,
                      ),
                    ],
                    onSelected: (index) async {
                      await pantryProvider.popMenuAction(
                          index, pantryModel, username);
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: greyColor.withOpacity(0.3),
              thickness: 1,
              height: 8,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                    child: info(
                        "Categories", "${pantryModel.numberOfCategories}")),
                Expanded(
                    child: info("Products", "${pantryModel.numberOfProducts}")),
                Expanded(
                    child: info("Shopping list",
                        "${pantryModel.numberOfShoppingList}")),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(child: info("Recipes", "N")),
                Expanded(
                    child: info("Members", "${pantryModel.members.length}")),
                Expanded(child: info("", "")),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class PantryLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pantryProvider = locator<SelectPantryProvider>();
    var selected = pantryProvider.currentPantry[0];
    return GestureDetector(
        onTap: () {
          pantryProvider.navigationService.pushReplacementName(selectPantry);
        },
        child: Align(
            child: Container(
                padding: EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  radius: 20,
                  child: Center(
                    child: Text(
                      selected,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  backgroundColor: Color(0xff152238),
                ))));
  }
}
