import 'package:spiry/locator.dart';
import 'package:spiry/services/navigation/routepaths.dart';
import 'package:spiry/utilities/styles.dart';
import 'package:spiry/views/authentication/authenticationprovider.dart';
import 'package:flutter/material.dart';


class HaveAccount extends StatelessWidget {
  final String message;
  final String navigateTo;
  final Function function;

  HaveAccount({this.message, this.navigateTo,this.function});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: InkWell(
        onTap: () {
          final  authenticationProvider = locator<AuthenticationProvider>();
//          navigateTo == signInScreen
//              ? authenticationProvider.switchAuthenticationScreen(signInScreen)
//              : authenticationProvider.switchAuthenticationScreen(registerScreen);
           authenticationProvider.changeScreen(navigateTo == signInScreen ? 0 : 1);
           function();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.15, vertical: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: message,
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: [
                  TextSpan(
                    text: navigateTo == signInScreen ? 'Sign In' : 'Register',
                    style: TextStyle(color: orangeColor, fontSize: 16),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
