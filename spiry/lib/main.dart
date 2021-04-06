import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spiry/views/authentication/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:spiry/locator.dart';
import 'package:spiry/views/bottomnav/bottomnav.dart';

import 'services/navigation/navigationservice.dart';
import 'services/navigation/router.dart';

void main(){
 // WidgetsFlutterBinding.ensureInitialized();
 // Firestore.instance.settings(
 //     sslEnabled: false,
 //     host:"10.0.2.2:8080",
 //     persistenceEnabled: false
 // );
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // onGenerateRoute: Router.generateRoute,
      navigatorKey: locator<NavigationService>().navigationKey,
      home: HomeBottomNavbar(),
    );
  }
}