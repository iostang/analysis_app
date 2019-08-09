
class DetailConfigModel {
  int code;
  String msg;
  List<DetailConfigData> data;

  DetailConfigModel({this.code, this.msg, this.data});

  DetailConfigModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<DetailConfigData>();
      json['data'].forEach((v) {
        data.add(new DetailConfigData.fromJson(v));
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

class DetailConfigData {
  String name;
  String title;
  List<IndexList> indexList;

  DetailConfigData({this.name, this.title, this.indexList});

  DetailConfigData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    if (json['index_list'] != null) {
      indexList = new List<IndexList>();
      json['index_list'].forEach((v) {
        indexList.add(new IndexList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    if (this.indexList != null) {
      data['index_list'] = this.indexList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IndexList {
  String name;
  String title;

  IndexList({this.name, this.title});

  IndexList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    return data;
  }
}