import 'package:flutter/material.dart';

class LabeledRadio extends StatelessWidget {
  final Text label;
  final Text subLabel;
  final  groupValue;
  final  value;
  final activeColor;
  final Function onChanged;

  const LabeledRadio({
    this.label,
    this.subLabel,
    this.groupValue,
    this.value,
    this.activeColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        if (value != groupValue)
          onChanged(value);
      },
      child: Row(
        children: <Widget>[
          Radio(
            groupValue: groupValue,
            activeColor: activeColor,
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              subLabel != null ? SizedBox(height: 12,): Container(),
              label,
              subLabel != null ? SizedBox(height: 3,):Container(),
              subLabel != null ? subLabel :Container(),
            ],
          ),
        ],
      ),
    );
  }
}