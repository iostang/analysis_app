class OrderChartModel {
  int code;
  String msg;
  List<OrderChartData> data;

  OrderChartModel({this.code, this.msg, this.data});

  OrderChartModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<OrderChartData>();
      json['data'].forEach((v) {
        data.add(new OrderChartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderChartData {
  String date;
  OrderChartValue value;

  OrderChartData({this.date, this.value});

  OrderChartData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    value = json['value'] != null ? new OrderChartValue.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.value != null) {
      data['value'] = this.value.toJson();
    }
    return data;
  }
}

class OrderChartValue {
  int roomNightCount;
  int effectOrderNum;
  int notEffectOrderNum;
  double amount;

  OrderChartValue(
      {this.roomNightCount,
      this.effectOrderNum,
      this.notEffectOrderNum,
      this.amount});

  OrderChartValue.fromJson(Map<String, dynamic> json) {
    roomNightCount = json['room_night_count'];
    effectOrderNum = json['effect_order_num'];
    notEffectOrderNum = json['not_effect_order_num'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_night_count'] = this.roomNightCount;
    data['effect_order_num'] = this.effectOrderNum;
    data['not_effect_order_num'] = this.notEffectOrderNum;
    data['amount'] = this.amount;
    return data;
  }
}