import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:analysis_app/model/detail_config_model.dart';
import 'package:analysis_app/model/home_page_model.dart';
import 'package:analysis_app/model/login_model.dart';
import 'package:analysis_app/model/order_chart_data.dart';
import 'package:analysis_app/model/order_reason.dart';
import 'package:analysis_app/model/sell_channel.dart';

import 'tj_http_tool.dart';

class TjNet {
  static TjNet _net = TjNet();
  BuildContext context;
  static TjNet of(context) {
    _net.context = context;
    return _net;
  }

  Future<LoginModel> login(Map data) async {
    // Response value = await TjHttp.post("/login", data: data);
    // LoginModel model = LoginModel.fromJson(value.data);
    // return model;
    String value = await DefaultAssetBundle.of(context).loadString("data/login.json");
    LoginModel model = LoginModel.fromJson(json.decode(value));
    return model;
  }

  Future<LogoutModel> logout(Map<String, dynamic> data) async {
    return LogoutModel.fromJson({});
    // Response value = await TjHttp.delete("/logout?user_id=${data['user_id']}");
    // LogoutModel model = LogoutModel.fromJson(value.data);
    // return model;
  }

  Future<HomePageModel> fetchHomePageData({Map data}) async {
    String value = await DefaultAssetBundle.of(context).loadString("data/homepage.json");
    HomePageModel model = HomePageModel.fromJson(json.decode(value));
    return model;
    // int uid = await getUserID();
    // Response value = await TjHttp.get("/api/v1/home", data: {"user_id": uid});
    // return HomePageModel.fromJson(value.data);
  }

  Future<DetailConfigModel> fetchDetailPageData({Map data}) async {
    String value = await DefaultAssetBundle.of(context).loadString("data/tabs.json");
    DetailConfigModel model = DetailConfigModel.fromJson(json.decode(value));
    return model;
    // int uid = await getUserID();
    // Response value = await TjHttp.get("/api/v1/tabs", data: {"user_id": uid});
    // return DetailConfigModel.fromJson(value.data);
  }

  Future<SellChannelModel> fetchSellChannelData(int days) async {
    String value = await DefaultAssetBundle.of(context).loadString("data/sell_channel.json");
    SellChannelModel model = SellChannelModel.fromJson(json.decode(value));
    return model;
    // int uid = await getUserID();
    // Response value = await TjHttp.post("/api/v1/order/sell_channel",
    //     data: {"days": days, "user_id": uid});
    // return SellChannelModel.fromJson(value.data);
  }

  Future<OrderReasonModel> fetchCancelReasonData(int days) async {
    String value = await DefaultAssetBundle.of(context).loadString("data/order_reason.json");
    OrderReasonModel model = OrderReasonModel.fromJson(json.decode(value));
    return model;
    // int uid = await getUserID();
    // Response value = await TjHttp.post("/api/v1/order/cancel_reason",
    //     data: {"days": days, "user_id": uid});
    // return OrderReasonModel.fromJson(value.data);
  }

  Future<OrderChartModel> fetchDetailData(int days) async {
    String value = await DefaultAssetBundle.of(context).loadString("data/order_chart_data.json");
    OrderChartModel model = OrderChartModel.fromJson(json.decode(value));
    return model;
    // int uid = await getUserID();
    // Response value = await TjHttp.post("/api/v1/order/detail",
    //     data: {"days": days, "user_id": uid});
    // return OrderChartModel.fromJson(value.data);
  }

  Future<int> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt("token");
    return uid;
  }
}
