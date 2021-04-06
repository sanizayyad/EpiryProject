import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';

class BusyLoading extends StatelessWidget {
  final type;

  BusyLoading({this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(vertical: 14,),
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  type == 'orange' ? orangeColor : greenColor
              ),
            )),
      ],
    );
  }
}
