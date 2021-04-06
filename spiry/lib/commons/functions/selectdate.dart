
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future selectDate(context, controller, callBack) async {
  FocusScope.of(context).requestFocus(FocusNode());
  DateFormat dateFormat = DateFormat.yMMMd();

  var initialDate = controller.text != "" ? dateFormat.parse("${controller.text}, 2020") : null ;
  //changed to calendar picker
  DateTime picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark(),
        child: child,
      );
    },
  );
  if (picked != null){
    controller.text = dateFormat.format(picked);
    callBack();
  }
}

