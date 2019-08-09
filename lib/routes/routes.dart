
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String analysis = "/analysis";
  static String analysisPush = "/analysis/push";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> parameters) {
      print("ROUTE WAS NOT FOUND !!! ${parameters.toString()}");
    });
    router.define(root, handler: rootHandler);

    router.define(analysis, handler: analysisRouteHandler);

    router.define(analysisPush, handler: analysisRouteHandler, transitionType: TransitionType.inFromRight);
  }
}
