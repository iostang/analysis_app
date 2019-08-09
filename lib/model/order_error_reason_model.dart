class OrderErrorReasonModel {
  String msg;
  int code;
  Map<String, dynamic> dict;

  OrderErrorReasonModel({this.msg, this.code, this.dict});

  OrderErrorReasonModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    dict = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.dict;
    return data;
  }
}

class OrderErrorReasonData {
  int count;
  String date;
  String reason;

  OrderErrorReasonData({this.count, this.date, this.reason});

  OrderErrorReasonData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    date = json['date'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['date'] = this.date;
    data['reason'] = this.reason;
    return data;
  }
}