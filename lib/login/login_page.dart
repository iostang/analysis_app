/// 登陆页

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:analysis_app/localizations/localizations.dart';
import 'package:analysis_app/net/tj_net.dart';
import 'package:analysis_app/tools/config.dart';
import 'package:analysis_app/tools/hud.dart';
import 'package:analysis_app/tools/toast.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<bool> onTapLogin;
  LoginPage({this.onTapLogin});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var _showPassword = false;
  final _phoneFocusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  final _phoneTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TjLocalizations.of(context).login,
          style: TextStyle(
              fontFamily: "Avenir-Black",
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: getStackBody(),
    );
  }

  Widget getStackBody() {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        body(),
        loading(),
      ],
    );
  }

  Widget loading() {
    return Opacity(
      opacity: _isLoading ? 1.0 : 0.0,
      child: Container(
        child: Center(
          child: TjHUD.getLoading(),
        ),
      ),
    );
  }

  Widget body() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return GestureDetector(
      onTap: () {
        _phoneFocusNode.unfocus();
        _pwdFocusNode.unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          width: width,
          height: height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Image.asset("images/login_logo.png"),
                ),
                mailTF(),
                pwdTF(),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                loginButton(),
                Expanded(
                  flex: 10,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mailTF() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF979797),
          width: 0.5,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
      ),
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: _phoneTextController,
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration.collapsed(
              hasFloatingPlaceholder: true,
              hintText: TjLocalizations.of(context).inputAccount,
              hintStyle: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12),
            ),
            onSaved: (value) {},
          ),
        ),
      ),
    );
  }

  Widget pwdTF() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF979797),
          width: 0.5,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
      ),
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _pwdTextController,
              focusNode: _pwdFocusNode,
              obscureText: !_showPassword,
              decoration: InputDecoration.collapsed(
                hasFloatingPlaceholder: true,
                hintText: TjLocalizations.of(context).inputPwd,
                hintStyle: TextStyle(color: Color(0xFFA3A3A3), fontSize: 12),
              ),
              onSaved: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton() {
    return Container(
      height: 38,
      width: 148,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: AppColor.theme,
        highlightColor: AppColor.theme,
        child: Text(
          TjLocalizations.of(context).login,
          style: TextStyle(
              fontSize: 12, color: Colors.white, fontFamily: "Avenir-Black"),
        ),
        onPressed: () {
          handleLoginAction();
        },
      ),
    );
  }

  void handleLoginAction() async {
    _phoneFocusNode.unfocus();
    _pwdFocusNode.unfocus();

    setState(() {
      _isLoading = true;
    });

    String mail = _phoneTextController.text;
    String pwd = _pwdTextController.text;

    if (mail.isEmpty) {
      _isLoading = false;
      TjToast.show("请输入账号");
      return;
    }
    if (pwd.isEmpty) {
      _isLoading = false;
      TjToast.show("请输入密码");
      return;
    }

    Map<String, dynamic> data = {"usr": mail, "pwd": pwd};

    SharedPreferences prefs = await SharedPreferences.getInstance();

    TjNet.of(context).login(data).then((model) {
      prefs.setInt("token", model.data.id);
      prefs.setString("name", "${model.data.displayName}");
      prefs.setString("mail", "${model.data.mail}");
      prefs.setString("session_id", "${model.data.sessionId}");
      setState(() {
        _isLoading = false;
        TjToast.show(TjLocalizations.of(context).loginSuccess);
        widget.onTapLogin(true);
      });
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      TjToast.show("登录失败");
    });
  }
}
