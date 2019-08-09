
class OrderDatas {
  String msg;
  int code;
  Map<String, dynamic> dict;
  OrderDatas({this.msg, this.code, this.dict});

  OrderDatas.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    dict = json["data"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code; 
    data['data'] = this.dict;
    return data;
  }
}

class OrderItem {
  int count;
  int ext;
  String desc;
  String date;

  OrderItem({this.count, this.desc, this.date, this.ext});

  OrderItem.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    desc = json['desc'];
    date = json['date'];
    ext =  json['ext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['desc'] = this.desc;
    data['date'] = this.date;
    data['ext'] = this.ext;
    return data;
  }
}