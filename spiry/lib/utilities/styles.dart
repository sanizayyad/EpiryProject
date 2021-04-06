import 'package:flutter/material.dart';
import 'dart:math';

final primaryColor = Colors.black87;

final orangeColor = Color(0xffF2631C);
final greenColor = Colors.green[800];
final greyColor = Color(0xff828282);
final greenColorLight = Colors.green[800].withOpacity(0.9);

List<Color> gradientRed = [Colors.red, Colors.redAccent];
List<Color> gradientBlue = [Colors.blue, Colors.lightBlue];
List<Color> gradientGreen = [Colors.green, Colors.lightGreen];
List<Color> gradientGray = [Color(0xff7D7D7D), Color(0xff9E9E9E)];
Color greyBg =  Colors.grey[200];
Map<String, List<Color>> colorGradient = {
  "red": gradientRed,
  "blue": gradientBlue,
  "green": gradientGreen,
  "grey": gradientGray
};

class RandomColor {
  static Color RandCol() {
    Random rand = Random();
    return Color(0xff000000 + rand.nextInt(0x00ffffff));
  }
}
