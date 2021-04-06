import 'dart:io';

import 'package:spiry/commons/functions/databasecommons.dart';
import 'package:spiry/commons/functions/imagepicker.dart';
import 'package:spiry/commons/functions/validators.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/models/usermodel.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/authentication/authenticationprovider.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SettingsProvider extends BaseProviderModel {
  File image;
  UserModel userModel;
  BuildContext context;

  Future pickImage(context) async {
    image = await imagePicker(context);
    if (image != null) {
      setViewState(ViewState.Busy);
      String imageUrl = await fireStoreService.uploadFile(image, "profile_photo");
      try {
        var file = await DefaultCacheManager().getSingleFile(userModel.imageUrl);
        file.delete();
        fireStoreService.updateUser({
          "imageUrl": imageUrl
        });
        setViewState(ViewState.Idle);
        image = null;
      }catch (e) {
        print(e.message);
      }

    }
  }

  Future<bool> editUsername() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();
    controller.text = userModel.username;
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("Edit Username"),
              content: Container(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: controller,
                      autofocus: true,
                      validator: userNameValidator,
                      decoration: InputDecoration(
                          labelText: "Username",
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
              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      navigationService.pop(true);
                      var oldUser = userModel;
                      await fireStoreService.updateUser({
                        "username": controller.text.trim(),
                      });
                      showToast("username edited successfully", context);
                      await fireStoreService.editUsername(oldUser,controller.text.trim());
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

  Future<bool> editReminders() {
    UserModel user = userModel;
    Widget check(reminder, func) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                activeColor: Colors.deepOrange,
                value: reminder.isActive,
                onChanged: func,
              ),
              SizedBox(width: 20,),
              Text(reminder.time, style: TextStyle(
                fontSize: 18,
              ),),
            ],
          ),
          Divider(height: 2, color: greyColor,)
        ],
      );
    }
    void checkAll(){
      int checked = 0;
      user.reminders.forEach((reminder){
        if(!reminder.isActive)
          checked++;
      });
      if(user.reminders.length == checked){
        user.expiryNotification = false;
      }
    }
    return showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (context,setState){
              return AlertDialog(
                title: Text("Edit Reminders"),
                content: Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    width: MediaQuery.of(context).size.height*0.7,
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Expiry Notification", style: TextStyle(
                                        fontSize: 16,
                                        color: greyColor
                                    ),),
                                    Spacer(),
                                    Switch(
                                        activeColor: Colors.deepOrange,
                                        value: user.expiryNotification,
                                        onChanged: (val){
                                          user.expiryNotification = val;
                                          setState(() {});
                                        })
                                  ],
                                ),
                                Text("Time setting", style: TextStyle(
                                    fontSize: 16,
                                    color: greyColor
                                ),),
                              ],
                            )
                        ),
                        IgnorePointer(
                          ignoring: user.expiryNotification ? false : true,
                          child: Opacity(
                            opacity:  user.expiryNotification ? 1 : 0.5,
                            child: Column(
                              children: user.reminders.map((reminder) =>
                                  check(reminder,(bool value) {
                                    reminder.isActive = value;
                                    checkAll();
                                    setState(() {});
                                  },)).toList(),
                            ),
                          ),
                        )
                      ],
                    )
                ),
                titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      navigationService.pop(true);
                      await fireStoreService.updateUser({
                        "expiryNotification": user.expiryNotification,
                        'reminders': user.reminders.map((e) => e.toJson()).toList()
                      });
                      showToast("reminders edited successfully", this.context);
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
              );
            })
    );
  }

  String reminderMessage(){
  String activeReminders = '';
  userModel.reminders.map((reminder){
    if(reminder.isActive){
      activeReminders += ", ${reminder.time}";
    }
  }).toList();

 return userModel.expiryNotification ? activeReminders.substring(2) : "disabled";

}

  Future<bool> deleteAccountDialog() {
    return showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("Are you sure you want to delete this Account ? "),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    navigationService.pop(true);
                    await locator<AuthenticationProvider>().deleteAccount();
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
}