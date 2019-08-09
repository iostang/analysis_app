import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class TjToast {

  static void show(String text,{double time}) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: time == null ? 1 : time,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}