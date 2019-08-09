
import 'package:flutter/material.dart';
import 'package:tj_analysis/home/home_page.dart';
import 'package:tj_analysis/localizations/localizations.dart';
import 'package:tj_analysis/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tj_analysis/net/tj_net.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _RootPageState.getToken(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return LoginPage(
              onTapLogin: (login) {
                setState(() {});
              },
            );
          }

          return HomePage(
            title: TjLocalizations.of(context).appName,
            onTapDrawer: (drawer) {
              logout();
            },
          );
        } else {
          return HomePage(
            title: TjLocalizations.of(context).appName,
            onTapDrawer: (drawer) {
              logout();
            },
          );
        }
      },
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await TjNet.of(context).logout({"user_id":prefs.getInt("token")});
    prefs.setInt("token", null);
    setState(() {});
  }

  static Future<int> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int token = prefs.getInt('token');
    return token;
  }
}
