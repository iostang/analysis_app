import 'package:tj_analysis/home/detail_page.dart';
import 'package:tj_analysis/home/home_page.dart';

import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tj_analysis/localizations/free_localizations.dart';
import 'package:tj_analysis/tools/colors_helpers.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomePage();
});

var analysisRouteHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String colorHex = params["color_hex"]?.first;
  Color color = Color(0xFFFFFFFF);
  if (colorHex != null && colorHex.length > 0) {
    color = Color(ColorHelpers.fromHexString(colorHex));
  }
  return FreeLocalizations(
    child: DetailPage(
      backgroundColor: color,
    ),
  );
});