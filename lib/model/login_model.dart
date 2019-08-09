class LogoutModel {
  int code;
  String msg;

  LogoutModel({this.code, this.msg});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    return data;
  }
}

class LoginModel {
  int code;
  String msg;
  UserModel data;
  
  LoginModel({this.code, this.msg, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
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

class UserModel {
  int id;
  String displayName;
  String cn;
  String mail;
  String description;
  String sessionId;

  UserModel(
      {this.id,
      this.displayName,
      this.cn,
      this.mail,
      this.description,
      this.sessionId});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    cn = json['cn'];
    mail = json['mail'];
    description = json['description'];
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['cn'] = this.cn;
    data['mail'] = this.mail;
    data['description'] = this.description;
    data['session_id'] = this.sessionId;
    return data;
  }
}