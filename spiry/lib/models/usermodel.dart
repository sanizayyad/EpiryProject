import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String userID;
  String username;
  String email;
  String imageUrl;
  bool isNewUser;
  bool expiryNotification;
  List<NotificationReminders> reminders;
  Map pantriesReference;

  UserModel(
      {this.userID,
      this.username,
      this.email,
      this.imageUrl,
      this.expiryNotification,
      this.reminders,
      this.isNewUser,
        this.pantriesReference
      });

  factory UserModel.fromFireStore(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    List reminders = data['reminders'];
    return UserModel(
      userID: data['userID'],
      username:  data['username'] ?? "username",
      email: data['email'],
      imageUrl: data['imageUrl'] ?? "",
      expiryNotification: data['expiryNotification'],
      reminders:  reminders?.map((item)=>NotificationReminders.fromMap(item))?.toList(),
      pantriesReference: data['pantriesReference'],
    );
  }

  factory UserModel.fromFirebaseAuth(FirebaseUser user, bool isNew){
    if (user == null) return null;
    return UserModel(
      userID: user.uid,
      username:  user.displayName ?? "username",
      email: user.email,
      imageUrl: user.photoUrl ?? "",
      isNewUser: isNew,
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "userID": userID,
      "username": username?.trim(),
      "email": email,
      "imageUrl": imageUrl,
      "expiryNotification" : expiryNotification,
      "reminders" : reminders.map((e) => e.toJson()).toList(),
      "pantriesReference": pantriesReference ?? {}
    };
  }
}

class NotificationReminders{
  String time;
  bool isActive;
  NotificationReminders({this.time,this.isActive});

  factory NotificationReminders.fromMap(Map data){
    return NotificationReminders(
      time: data['time'],
      isActive: data['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "time": time ?? '',
      "isActive": isActive ?? false,
    };
  }

  static List<NotificationReminders> reminders(){
    List<NotificationReminders> reminders;
    reminders  = List.generate(24,(int i){
      var time = i.toString().length == 1 ? "0$i" : i;
      bool isActive = i == 10 || i == 16 ? true  : false;
      return NotificationReminders(time: "$time:00",isActive: isActive);
    });
    return reminders;
  }
}