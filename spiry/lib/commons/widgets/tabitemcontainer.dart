import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';

class TabItemContainer extends StatelessWidget {
  final String title;
  final IconData iconData;

  TabItemContainer({this.title, this.iconData});

  @override
  Widget build(BuildContext context) {
    bool icon = iconData != null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: icon ? 8 : 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: primaryColor, width: 1),
      ),
      child: Align(
        alignment: Alignment.center,
        child: icon
            ? Icon(
          iconData,
          size: 20,
        )
            : Text(title),
      ),
    );
  }
}
