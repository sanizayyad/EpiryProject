import 'package:spiry/commons/widgets/logo.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';

import '../../../locator.dart';
import '../authenticationprovider.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    locator<AuthenticationProvider>().handleStartUpLogic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Logo(height: 300),
            SizedBox(height: 20,),
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(orangeColor),
            )
          ],
        ),
      ),
    );
  }
}
