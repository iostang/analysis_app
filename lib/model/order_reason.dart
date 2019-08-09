class OrderReasonModel {
  int code;
  String msg;
  OrderReasonData data;

  OrderReasonModel({this.code, this.msg, this.data});

  OrderReasonModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderReasonData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OrderReasonData {
  List<OrderReasonTypes> types;
  List<OrderReasonNums> nums;

  OrderReasonData({this.types, this.nums});

  OrderReasonData.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      types = new List<OrderReasonTypes>();
      json['types'].forEach((v) {
        types.add(new OrderReasonTypes.fromJson(v));
      });
    }
    if (json['nums'] != null) {
      nums = new List<OrderReasonNums>();
      json['nums'].forEach((v) {
        nums.add(new OrderReasonNums.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.types != null) {
      data['types'] = this.types.map((v) => v.toJson()).toList();
    }
    if (this.nums != null) {
      data['nums'] = this.nums.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderReasonTypes {
  String type;
  int num;
  double percent;

  OrderReasonTypes({this.type, this.num, this.percent});

  OrderReasonTypes.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    num = json['num'];
    String v = json['percent'].toString();
    percent = double.parse(v);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['num'] = this.num;
    data['percent'] = this.percent;
    return data;
  }
}

class OrderReasonNums {
  int num;
  String date;

  OrderReasonNums({this.num, this.date});

  OrderReasonNums.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['date'] = this.date;
    return data;
  }
}