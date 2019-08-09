class SellChannelModel {
  int code;
  String msg;
  List<SellChannelData> data;

  SellChannelModel({this.code, this.msg, this.data});

  SellChannelModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<SellChannelData>();
      json['data'].forEach((v) {
        data.add(new SellChannelData.fromJson(v));
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

class SellChannelData {
  String sellChannel;
  int number;
  double percent;

  SellChannelData({this.sellChannel, this.number});

  SellChannelData.fromJson(Map<String, dynamic> json) {
    sellChannel = json['sell_channel'];
    number = json['num'];
    String v = json['percent'].toString();
    percent = double.parse(v);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sell_channel'] = this.sellChannel;
    data['num'] = this.number;
    return data;
  }
}