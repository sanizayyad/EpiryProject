import 'package:spiry/commons/widgets/busyloading.dart';
import 'package:spiry/commons/widgets/imageselector.dart';
import 'package:spiry/models/usermodel.dart';
import 'package:spiry/utilities/consttexts.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/authentication/authenticationprovider.dart';
import 'package:spiry/views/base/baseprovider.dart';
import 'package:spiry/views/pantry/selectpantry.dart';
import 'package:spiry/views/settings/settingsprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class Settings extends StatelessWidget {
  List<String> popupmenu = [
    "Logout",
    "Delete Account"
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (_,settingsProvider,child){
        settingsProvider.context = context;
        return StreamBuilder<UserModel>(
          stream: settingsProvider.fireStoreService.userStream(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Center(child: BusyLoading(type: 'orange',),);
             settingsProvider.userModel = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  leading: PantryLogo(),
                  title: Text("Settings", style: TextStyle(
                      color: primaryColor
                  ),),
                  actions: <Widget>[
                    PopupMenuButton(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.more_vert,color: primaryColor,)),
                      itemBuilder: (context) => <PopupMenuItem>[
                        PopupMenuItem(
                          child: Text(popupmenu[0]),
                          value: 0,
                        ),
                        PopupMenuItem(
                          child: Text(popupmenu[1]),
                          value: 1,
                        ),
                      ],
                      onSelected: (index){
                        if(index == 0){
                          locator<AuthenticationProvider>().signOut();
                        }else if(index == 1){
                          settingsProvider.deleteAccountDialog();
                        }
                      },
                    ),
                  ],

                ),
                backgroundColor: greyBg,
                body: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    SizedBox(height: 10,),
                    settingsProvider.viewState == ViewState.Busy
                        ? BusyLoading(type: 'orange',)
                        :ProfileImage(
                      user: settingsProvider.userModel,
                      provider: settingsProvider,
                    ),
                    SizedBox(height: 20,),
                    GroupContainer(
                      groupTitle: "Profile Settings",
                      items: <Widget>[
                        InkWell(
                          onTap: (){
                            settingsProvider.editUsername();
                          },
                          child: SettingItem(
                            setting: "Name",
                            value: settingsProvider.userModel.username,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            settingsProvider.editReminders();
                            settingsProvider.setViewState(ViewState.Idle);
                          },
                          child: SettingItem(
                            setting: "Notification Reminder",
                            value: settingsProvider.reminderMessage(),
                          ),
                        ),
                        SettingItem(
                          setting: "Language",
                          value: "English",
                        ),
                        SettingItem(
                          setting: "Theme",
                          value: "Light",
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    GroupContainer(
                      items: <Widget>[
                        SettingItem(
                          setting: "Support",
                        ),
                        SettingItem(
                          setting: "Help",
                        ),
                        SettingItem(
                          setting: "Invite friend",
                        ),
                        SettingItem(
                          setting: "Send Feedback",
                        ),
                        SettingItem(
                          setting: "Rate us",
                        ),
                      ],
                    ),

                  ],
                )
            );
          }
        );
      },
    );
  }
}

class ProfileImage extends StatelessWidget {
  final provider;
  final UserModel user;
  ProfileImage({this.user,this.provider});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Align(
            child: Container(
              width: 110,
              child: ImageSelector(
                productImage: user.imageUrl ?? defaultImageUrl,
                provider: provider,
                height: 110,
                circular: true,
              ),),
          ),
          SizedBox(height: 10,),
          Text("${user.username}",style: TextStyle(
            fontSize: 17,
            color:Colors.black,
          )),
          SizedBox(height: 5,),
          Text("${user.email}",style: TextStyle(
            fontSize: 13,
            color:Colors.grey,
          )),
        ],
      ),
    );
  }
}


class SettingItem extends StatelessWidget {
  final setting;
  final value;
  SettingItem({this.setting,this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4,12,6,12),
      child: Row(
        children: <Widget>[
          Text(setting,style: TextStyle(
            fontSize: 16,
            color:Colors.grey,
          )),
          Spacer(),
          value != null ? Container(
            width: MediaQuery.of(context).size.width*0.4,
            child: Text(value,
            style: TextStyle(
              fontSize: 16,
              color:Colors.black,),
                maxLines: 1,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}


class GroupContainer extends StatelessWidget {
  final groupTitle;
  final List<Widget> items;

  GroupContainer({this.groupTitle,this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          groupTitle != null ? Text(groupTitle,style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w400
          )) : SizedBox(),
          groupTitle != null ?SizedBox(height: 15,) : SizedBox(),
          Column(
            children: items.map((setting){
              return Column(
                children: <Widget>[
                  setting,
                  items.last != setting
                      ? Divider(thickness: 1,color: Colors.grey.withOpacity(0.4),height: 5,)
                      : SizedBox()
                  ,
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class DeleteLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BusyLoading(type: 'orange',),
      ),
    );
  }
}
