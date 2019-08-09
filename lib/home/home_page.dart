import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/foundation.dart';

import 'package:analysis_app/home/drawer_page.dart';
import 'package:analysis_app/localizations/localizations.dart';
import 'package:analysis_app/model/home_page_model.dart';
import 'package:analysis_app/net/tj_net.dart';
import 'package:analysis_app/routes/application.dart';
import 'package:analysis_app/routes/routes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.onTapDrawer}) : super(key: key);

  final String title;
  final ValueChanged<bool> onTapDrawer;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> items = List<String>();

  RefreshController _refreshController;

  List<Color> colors = [
    Color(0xFF4B89D8),
    Color(0xFFE35BA0),
    Color(0xFF33C3C8),
    Color(0xFF915CE3),
    Color(0xFFFFBA00),
    Color(0xFF90C224)
  ];

  void _onRefresh() {
    fetchDatas(context).then((onValue) {
      setState(() {
        _refreshController.refreshCompleted();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomePageModel>(
      future: fetchDatas(context),
      builder: (BuildContext context, AsyncSnapshot<HomePageModel> snapshot) {
        return buildScaffoldView(snapshot.data);
      },
    );
  }

  Widget buildScaffoldView(HomePageModel model) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFAFAFA),
      drawer: MenuPage(onTapMenu: (tap) {
        _scaffoldKey.currentState.openEndDrawer();
        widget.onTapDrawer(true);
      }),
      appBar: AppBar(
        leading: MaterialButton(
          onPressed: () {
            if (_scaffoldKey.currentState != null) {
              _scaffoldKey.currentState.openDrawer();
            }
          },
          child: Image.asset("images/home_user_menu.png"),
        ),
        title: Text(
          TjLocalizations.of(context).appName,
          style: TextStyle(
              fontFamily: "Avenir-Black",
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: defaultTargetPlatform == TargetPlatform.iOS
              ? WaterDropHeader()
              : ClassicHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          // onLoading: _onLoading,
          child: model == null ? Text("") : buildRootView(model),
        ),
      ),
    );
  }

  Widget buildRootView(HomePageModel model) {
    return ListView(
      children: <Widget>[
        buildMenuView(model),
        buildAppListView(model),
      ],
    );
  }

  Widget buildMenuView(HomePageModel model) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 2;
    final double itemHeight = 120;

    return Container(
      color: Colors.transparent,
      child: GridView.builder(
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.data.menuList.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemBuilder: (BuildContext context, int index) {
          return buildCell(context, model, index);
        },
      ),
    );
  }

  Widget buildCell(BuildContext context, HomePageModel model, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                          color: colors[index % colors.length],
                          width: 6,
                          height: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        model.data.menuList[index].title,
                        style: TextStyle(
                            color: colors[index],
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Text("${model.data.menuList[index].value}",
                    maxLines: 1,
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Color(0xFF55565F),
                        fontSize: 24,
                        fontFamily: "Avenir-Black")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppListView(HomePageModel model) {
    double h = model.data.appList.length * 100.0;
    return Container(
      height: h,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.data.appList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
            onTap: () {
              pushDetail();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                    height: 50,
                    color: Color(0xFF7D8DFF),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            model.data.appList[index].title,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Image.asset("images/btn_more.png")
                        ],
                      ),
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<HomePageModel> fetchDatas(BuildContext context) async {
    HomePageModel model = await TjNet.of(context).fetchHomePageData();
    return model;
  }

  void pushDetail() {
    Application.push(context,
        path: "${Routes.analysis}?message=Hello!&color_hex=#ffffff");
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
  
}
