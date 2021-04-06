import 'package:spiry/utilities/styles.dart';
import 'package:flutter/material.dart';

class DateTag extends StatelessWidget {
  final String expiryDate;
  final String category;
  final bool whiteOnblack;
  DateTag({this.expiryDate, this.category, this.whiteOnblack});

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Container(
          padding: whiteOnblack ? EdgeInsets.symmetric(horizontal: 5): null,
          height: 20,
          decoration: whiteOnblack ? BoxDecoration(
            color: primaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ): null,
          child: Center(
            child: Text(
              expiryDate,
              style: TextStyle(
                color: whiteOnblack ? Colors.white : primaryColor.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 20,
          width: whiteOnblack && category.length > 9 ? 70 : null,
          decoration: BoxDecoration(
            color: whiteOnblack ? primaryColor.withOpacity(0.6): Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: whiteOnblack ? Colors.white : primaryColor.withOpacity(0.5),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
