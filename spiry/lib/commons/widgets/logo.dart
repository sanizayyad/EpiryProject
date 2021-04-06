import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double height;

  Logo({this.height = 200});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16.0),
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/logo.png'),
          )),
    );
  }
}
