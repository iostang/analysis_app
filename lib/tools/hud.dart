import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:analysis_app/tools/config.dart';

class TjHUD {
  static Widget getLoading() {
    return SpinKitFadingCircle(color: AppColor.theme);
  }
}