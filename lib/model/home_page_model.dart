class HomePageModel {
  int code;
  String msg;
  HomePageData data;

  HomePageModel({this.code, this.msg, this.data});

  HomePageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new HomePageData.fromJson(json['data']) : null;
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

class HomePageData {
  List<MenuList> menuList;
  List<AppList> appList;

  HomePageData({this.menuList, this.appList});

  HomePageData.fromJson(Map<String, dynamic> json) {
    if (json['menu_list'] != null) {
      menuList = new List<MenuList>();
      json['menu_list'].forEach((v) {
        menuList.add(new MenuList.fromJson(v));
      });
    }
    if (json['app_list'] != null) {
      appList = new List<AppList>();
      json['app_list'].forEach((v) {
        appList.add(new AppList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.menuList != null) {
      data['menu_list'] = this.menuList.map((v) => v.toJson()).toList();
    }
    if (this.appList != null) {
      data['app_list'] = this.appList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuList {
  String name;
  String title;
  String value;

  MenuList({this.name, this.title, this.value});

  MenuList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    if ((json['value'] is int) || (json['value'] is double)) {
      value = json['value'].toString();
    } else {
      value = json['value'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['value'] = this.value;
    return data;
  }
}

class AppList {
  String name;
  String title;

  AppList({this.name, this.title});

  AppList.fromJson(Map<String, dynamic> json) {
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