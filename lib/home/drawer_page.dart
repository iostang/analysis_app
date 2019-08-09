import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tj_analysis/localizations/localizations.dart';

class MenuPage extends StatefulWidget {
  final ValueChanged<bool> onTapMenu;

  MenuPage({Key key, this.onTapMenu}) : super(key: key);

  @override
  _MenuPageState createState() => new _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchDatas(context),
      builder:(BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          return buildRootView(snapshot.data);
      },
    );
  }

  Future<Map<String, dynamic>> fetchDatas(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name");
    String mail = prefs.getString("mail");
    return {"name": name, "mail": mail};
  }

  Widget buildRootView(Map<String, dynamic> data) {
    if (data == null) {
      return Center();
    }
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Drawer(
            child: Container(
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                currentAccountPicture: Container(
                    child: Image.asset("images/user_a.png"),
                    width: 60,
                    height: 60),
                accountName: Text(
                  data["name"] ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                accountEmail: Text(
                  data["mail"] ?? "",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                child: MaterialButton(
                  height: 38,
                  color: Colors.white,
                  onPressed: () {
                    widget.onTapMenu(true);
                  },
                  child: Text(
                    TjLocalizations.of(context).logout,
                    style: TextStyle(
                        color: Color(0xFF4D5FE4),
                        fontSize: 12,
                        fontFamily: "Avenir-Black"),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
