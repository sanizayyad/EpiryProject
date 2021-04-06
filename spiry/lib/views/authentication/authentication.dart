import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';
import 'authenticationprovider.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  @override
  void initState() {
    // TODO: implement initState
    locator<AuthenticationProvider>().changeScreen(0);
    super.initState();
  }

  @override
  void dispose() {
    locator.resetLazySingleton<AuthenticationProvider>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<AuthenticationProvider>(
        create: (BuildContext context) => locator<AuthenticationProvider>(),
      child: Consumer<AuthenticationProvider>(
        builder: (_,authenticationProvider,child)=>Scaffold(
          body: IndexedStack(
              index: authenticationProvider.screenIndex,
              children: authenticationProvider.initialScreens),
        ),
      ),
    );
  }
}

