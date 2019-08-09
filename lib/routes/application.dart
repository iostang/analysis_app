/*
 * fluro
 * Created by Yakka
 * https://theyakka.com
 * 
 * Copyright (c) 2018 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Application {
  static Router router;

  static push(BuildContext context, {String path}) {
    var trans = defaultTargetPlatform == TargetPlatform.iOS ? TransitionType.native : TransitionType.inFromRight;
    router.navigateTo(context, path, transition: trans);
  }
}
