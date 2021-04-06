import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';

class SignInRegisterButton extends StatelessWidget {
  final type;
  final callBackFunction;

  SignInRegisterButton({this.type, this.callBackFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: MaterialButton(
        color: type == 'Save' ? primaryColor : orangeColor,
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: (){
          callBackFunction();
        },
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
              fontSize: 18.0),
        ),
      ),
    );
  }
}
