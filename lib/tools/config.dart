import 'dart:math';

import 'package:flutter/material.dart';

class AppColor {
  static const theme = Color(0xFF7D8DFF);
  static const clear = Colors.transparent;

  static Color random() {
    return Color.fromARGB(255, Random().nextInt(256)+0, Random().nextInt(256)+0, Random().nextInt(256)+0);
}
}