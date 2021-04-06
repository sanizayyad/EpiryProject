import 'package:flutter/material.dart';

void openDropdown(GlobalKey dropdownButtonKey) {
  GestureDetector detector;
  void searchForGestureDetector(BuildContext element) {
    element.visitChildElements((element) {
      if (element.widget != null && element.widget is GestureDetector) {
        detector = element.widget;
        return false;

      } else {
        searchForGestureDetector(element);
      }
      return true;
    });
  }
  searchForGestureDetector(dropdownButtonKey.currentContext);
  assert(detector != null);

  detector.onTap();
}

