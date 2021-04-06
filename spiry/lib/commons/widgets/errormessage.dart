import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final errorMessage;
  ErrorMessage({this.errorMessage});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
      child: Text(
        errorMessage,
        style: TextStyle(
            color: Colors.red,
            fontSize: 15
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
