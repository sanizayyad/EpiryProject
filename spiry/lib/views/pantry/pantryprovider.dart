import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/models/pantry.dart';
import 'package:spiry/models/usermodel.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SelectPantryProvider extends BaseProviderModel {
  String currentPantry = "";
  UserModel userModel;
  BuildContext context;
//  bool isCurrentRoute = false;
  List<PantryModel> pantries = [];

  Future<void> changePantry(String pantryName, {bool setOrNot = true}) async {
    if (currentPantry != pantryName) {
       currentPantry = pantryName;
      await fireStoreService.changePantry(currentPantry,userModel);
      if (setOrNot)
        setViewState(ViewState.Idle);
    }
  }

  Future<void> getPantries(UserModel userModel) async {
    List<PantryModel> list = await fireStoreService.getPantries(userModel);
    if (!areListsEqual(pantries, list)) {
      pantries = list;
      setViewState(ViewState.Idle);
    }
  }
  bool areListsEqual(List<PantryModel> list1, List<PantryModel> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  Future<void> popMenuAction(int index, PantryModel pantryModel, String username) async {
    if (index == 0) {
//      await sharePantry(pantryModel, username);
      await deletePantry(pantryModel);
    }
//    else if (index == 1) {
//      await deletePantry(pantryModel);
//    }
  }

  Future<void> deletePantry(PantryModel pantryModel) async {
    if (pantryModel.pantryName == "Default Pantry") {
      showToast("Sorry you can't delete the default pantry", context);
    } else {
      await deletePantryDialog(pantryModel);
    }
  }

  Future<bool> addPantryDialog() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("New pantry Name"),
          content: Container(
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  validator: categoryValidator,
                  decoration: InputDecoration(
                      labelText: "Pantry name",
                      labelStyle: TextStyle(color: Colors.black),
                      focusColor: Colors.black,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                ),
              )),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  navigationService.pop(true);
                  setViewState(ViewState.Busy);
                  var pantriesNames = pantries
                      .map((pant) => pant.pantryName.toLowerCase())
                      .toList();
                  String pantryName = controller.text.trim();
                  if (!pantryName.toLowerCase().contains(" pantry")) {
                    pantryName += " Pantry";
                  }
                  if (!pantriesNames.contains(pantryName.toLowerCase())) {
                    await fireStoreService.addPantry(toBeginningOfSentenceCase(pantryName));
                    showToast("Pantry added successfully", context);
                  } else {
                    showToast("Pantry already exists, create a new pantry with a unique name!", context);
                  }
                  setViewState(ViewState.Idle);
                  controller.clear();
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
        ));
  }

  Future<bool> deletePantryDialog(PantryModel pantryModel) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
              "Are you sure you want delete this pantry and its contents"),
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                navigationService.pop(true);
                setViewState(ViewState.Busy);
                await fireStoreService.removePantry(pantryModel);
                await changePantry("Default Pantry");
                showToast("Pantry deleted successfully", context);
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
        ));
  }

//  Future<bool> acceptPantryDialog(Map queries) {
//    String username = queries['username'][0];
//    String refKey = queries['pantryRefKey'][0];
//    String refValue = queries['pantryRefValue'][0];
//    String signature = queries['signature'][0];
//
//    return showDialog(
//        context: context,
//        builder: (_) => AlertDialog(
//              title: Text("$username invited you to join $refKey"),
//              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//              contentPadding: EdgeInsets.symmetric(horizontal: 16),
//              actions: <Widget>[
//                FlatButton(
//                  onPressed: () async {
//                    navigationService.pop(true);
//                    var pantriesNames = pantries
//                        .map((pant) => pant.pantryName.toLowerCase())
//                        .toList();
//                    if (!pantriesNames.contains(refKey.toLowerCase())) {
//                      DocumentReference ref = Firestore.instance.document(refValue);
//                      PantryModel pantry;
//                      try {
//                        pantry = PantryModel.fromFireStore(await ref.get());
//                      } catch (e) {
//                        // TODO
//                      }
//                      if (pantry != null) {
//                        var signatureList = pantry.deepLinkExpiration[signature];
//                        if (signatureList != null) {
//                          pantry.members[userModel.username] = "Joined";
//                          pantry.deepLinkExpiration[signature][1] += 1;
//                          await ref.updateData({
//                            "members": pantry.members,
//                            "deepLinkExpiration":pantry.deepLinkExpiration[signature][1] == 3
//                                ? {}
//                                : pantry.deepLinkExpiration
//                          });
//
//                          userModel.pantriesReference[refKey] = ref;
//                          await fireStoreDatabaseRepo.updateUser(UserModel(
//                              pantriesReference: userModel.pantriesReference));
//                          await changePantry(refKey);
//                          showToast("Pantry Joined successfully", context);
//                        } else {
//                          showToast("Link has expired", context);
//                        }
//                      } else {
//                        showToast(
//                            "Unfortunately Pantry doesn't exist, it has been deleted", context);
//                      }
//                    } else {
//                      showToast(
//                          "Pantry already exists, create a new pantry with a unique name!", context);
//                    }
//                  },
//                  child: Text('Accept'),
//                ),
//                FlatButton(
//                  onP  ressed: () {
//                    navigationService.pop(false);
//                    showToast("You declined the invitation", context);
//                  },
//                  child: Text('Decline'),
//                ),
//              ],
//            ));
//  }


//  Future<void> sharePantry(PantryModel pantryModel, String username) async {
//    String link;
//
//    if (pantryModel.deepLinkExpiration.isNotEmpty) {
//      String signature = pantryModel.deepLinkExpiration.keys.toList()[0];
//      link = pantryModel.deepLinkExpiration[signature][0];
//    } else {
//      String key = pantryModel.pantryName;
//      String reference = pantryModel.reference;
//      String signature = barcodeGen();
//      String parameters =
//          'joinPantry?username=$username&pantryRefKey=$key&pantryRefValue=$reference&signature=$signature';
//
//      DynamicLinkService dynamic = locator<DynamicLinkService>();
//      link = await dynamic.createDynamicLink(parameters,
//          title: "Invitation to Join Pantry",
//          description: "$username invited you to join pantry");
//
//      pantryModel.deepLinkExpiration[signature] = [link, 0];
//      await fireStoreDatabaseRepo.updatePantry(PantryModel(
//          pantryName: pantryModel.pantryName,
//          deepLinkExpiration: pantryModel.deepLinkExpiration));
//    }
//
//    final RenderBox box = context.findRenderObject();
//    Share.share(link,
//        subject: "$username is inviting you to join Pantry",
//        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
//  }



  @override
  void dispose() {
//    super.dispose();
  }
}
