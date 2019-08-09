import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:analysis_app/charts/broken_charts.dart';
import 'package:analysis_app/charts/histogram_chart.dart';
import 'package:analysis_app/charts/pie_chart.dart';
import 'package:analysis_app/charts/test/donut_auto_label_chart.dart';


import 'package:analysis_app/localizations/localizations.dart';
import 'package:analysis_app/model/detail_config_model.dart';
import 'package:analysis_app/model/order_chart_data.dart';
import 'package:analysis_app/model/order_reason.dart';

import 'package:analysis_app/model/order_reason_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:analysis_app/model/sell_channel.dart';


import 'package:analysis_app/net/tj_net.dart';
import 'package:analysis_app/tools/config.dart';
import 'package:analysis_app/tools/hud.dart';

enum DetailMenuType {
  order_survey, //订单概况
  order_fail_reason, //无效订单原因分析
  sale_channel, //销售渠道分析
  other,
}

enum DetailMenuItemType {
  order_num, //订单数量
  room_night_count, //间夜量
  order_amount, //订单金额

  cancel_reason_num, //取消原因总量
  cancel_order_list, //取消订单列表

  sell_channel, //销售渠道

  other,
}

class DetailPage extends StatefulWidget {
  final Color backgroundColor;

  DetailPage({Key key, this.backgroundColor}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int dropValue = 7;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DetailConfigModel>(
      future: fetchDatas(context),
      builder:
          (BuildContext context, AsyncSnapshot<DetailConfigModel> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.white,
            child: Center(
              child: TjHUD.getLoading(),
            ),
          );
        }
        return buildController(snapshot);
      },
    );
  }

  Widget buildController(AsyncSnapshot<DetailConfigModel> snapshot) {
    DetailConfigModel model = snapshot.data;
    if (model.data == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            TjLocalizations.of(context).orderTitle,
            style: TextStyle(
                fontFamily: "Avenir-Black",
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: model.data.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            TjLocalizations.of(context).orderTitle,
            style: TextStyle(
                fontFamily: "Avenir-Black",
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Container(
                color: AppColor.theme,
                child:  DropdownButton(
                style: TextStyle(color: Colors.white, fontSize: 14),
                underline: Container(
                  color: Colors.transparent,
                ),
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.compare_arrows,
                    color: Colors.white,
                  ),
                ),
                //value: dropValue,
                items: [
                  DropdownMenuItem(
                    value: 7,
                    child: Text("周",style: TextStyle(color: Colors.black),),
                  ),
                  DropdownMenuItem(
                    value: 30,
                    child: Text("月",style: TextStyle(color: Colors.black),),
                  )
                ],
                onChanged: (value) {
                  setState(() {
                    dropValue = value;
                  });
                },
              ),)
          ],
          bottom: getAppbarBottom(model, snapshot.connectionState),
        ),
        body: getBodyView(model, snapshot.connectionState),
      ),
    );
  }


  Widget getAppbarBottom(DetailConfigModel model, ConnectionState state) {
    return TabBar(
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.white,
      isScrollable: true,
      tabs: model.data.map(
        (DetailConfigData item) {
          return Tab(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(item.title),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget getBodyView(DetailConfigModel model, ConnectionState state) {
    return TabBarView(
      children: model.data.map((DetailConfigData item) {
        return Padding(
          padding: EdgeInsets.all(12.0),
          child: DetailItemCard(
            choice: item,
            days:dropValue,
            onChanged: (value) {},
          ),
        );
      }).toList(),
    );
  }

  Future<DetailConfigModel> fetchDatas(context) async {
    DetailConfigModel model = await TjNet.of(context).fetchDetailPageData();
    return model;
  }
}

class DetailItemCard extends StatelessWidget {
  const DetailItemCard({Key key, this.choice, this.title, this.onChanged,this.days})
      : super(key: key);

  final DetailConfigData choice;
  final ValueChanged<String> onChanged;
  final String title;
  final int days;
  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.title;
    return FutureBuilder<List<List<charts.Series>>>(
      future: fetchDatas(context),
      builder: (BuildContext context,
          AsyncSnapshot<List<List<charts.Series>>> snapshot) {
        return getChartView(textStyle, choice.name, snapshot.data, context);
      },
    );
  }

  Widget getChartView(TextStyle textStyle, String type,
      List<List<charts.Series>> data, BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                data == null ? getLoadingView() : getWidget(choice.name, data),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getLoadingView() {
    return Container(
      color: Colors.white,
      child: Center(
        child: TjHUD.getLoading(),
      ),
    );
  }

  DetailMenuType transformMenuNameType(String type) {
    switch (type) {
      case "order_survey":
        return DetailMenuType.order_survey;
      case "order_fail_reason":
        return DetailMenuType.order_fail_reason;
      case "sale_channel":
        return DetailMenuType.sale_channel;
      default:
        return DetailMenuType.other;
    }
  }

  DetailMenuItemType transformMenuItemNameType(String type) {
    switch (type) {
      case "order_num":
        return DetailMenuItemType.order_num;
      case "room_night_count":
        return DetailMenuItemType.room_night_count;
      case "order_amount":
        return DetailMenuItemType.order_amount;
      case "cancel_reason_num":
        return DetailMenuItemType.cancel_reason_num;
      case "cancel_order_list":
        return DetailMenuItemType.cancel_order_list;
      case "sell_channel":
        return DetailMenuItemType.sell_channel;
      default:
        return DetailMenuItemType.other;
    }
  }

  Widget getWidget(String type, List<List<charts.Series>> data) {
    switch (transformMenuNameType(type)) {
      case DetailMenuType.order_survey:
      case DetailMenuType.order_fail_reason:
      case DetailMenuType.sale_channel:
        return Column(
          children: choice.indexList.asMap().keys.map(
            (idx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 15, 20),
                    child: Text(
                      choice.indexList[idx].title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: getMenuItemView(data[idx], choice.indexList[idx]),
                    height: getWidgetHeight(data[idx], choice.indexList[idx]),
                  ),
                ],
              );
            },
          ).toList(),
        );
      case DetailMenuType.other:
        return Text("loading...");
      default:
        return Text("loading...");
    }
  }

  double getWidgetHeight(List<charts.Series> data, IndexList item) {
    switch (transformMenuItemNameType(item.name)) {
      case DetailMenuItemType.cancel_order_list:
        return data.first.data.length * 60.0;
      case DetailMenuItemType.order_num:
        return 400;
      case DetailMenuItemType.cancel_reason_num:
        return 170;
      default:
        return 270;
    }
  }

  Widget getMenuItemView(
    final data,
    IndexList item,
  ) {
    switch (transformMenuItemNameType(item.name)) {
      case DetailMenuItemType.order_num:
        return HistogramChart(
          data,
        );
      case DetailMenuItemType.room_night_count:
        return BrokenChart(
          data,
        );
      case DetailMenuItemType.order_amount:
        return BrokenChart(
          data,
        );
      case DetailMenuItemType.cancel_order_list:
        return getCancelOrderList(data);
      case DetailMenuItemType.cancel_reason_num:
        return PieOutsideLabelChart(
          data,
        );
      case DetailMenuItemType.sell_channel:
        return PieChartView(
          data,
          animate: false,
        );
      case DetailMenuItemType.other:
        return DonutAutoLabelChart.withSampleData();
      default:
        return BrokenChart(data);
    }
  }

  Widget getCancelOrderList(final data) {
    List<charts.Series<OrderItem, String>> val = data;
    List<OrderItem> dataSources = val.last.data.reversed.toList();
    return Container(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataSources.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                          dataSources[index].date,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          "${dataSources[index].count}",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }

  Future<List<List<charts.Series>>> fetchDatas(BuildContext context) async {
    switch (transformMenuNameType(choice.name)) {
      case DetailMenuType.order_survey:
        return fetchOrderDatas(context);
      case DetailMenuType.order_fail_reason:
        return fetchCancelReasonDatas(context);
      case DetailMenuType.sale_channel:
        return fetchSellChannelDatas(context);
      case DetailMenuType.other:
        return fetchOrderDatas(context);
      default:
        return null;
    }
  }

  Future<List<List<charts.Series>>> fetchOrderDatas(
      BuildContext context) async {
    OrderChartModel datas =
        await TjNet.of(context).fetchDetailData(days);
    return getOrderChartDatas(datas);
  }

  Future<List<List<charts.Series>>> fetchCancelReasonDatas(
      BuildContext context) async {
    OrderReasonModel datas =
        await TjNet.of(context).fetchCancelReasonData(days);
    return getCancelReasonDatas(datas);
  }

  Future<List<List<charts.Series>>> fetchSellChannelDatas(
      BuildContext context) async {
    SellChannelModel datas =
        await TjNet.of(context).fetchSellChannelData(days);
    return getSellChannelDatas(datas);
  }

  List<List<charts.Series>> getCancelReasonDatas(OrderReasonModel datas) {
    var values = choice.indexList.map((indexModel) {
      var chartData = List<charts.Series<OrderItem, String>>();
      var types = transformMenuItemNameType(indexModel.name) ==
              DetailMenuItemType.cancel_order_list
          ? datas.data.nums
          : datas.data.types;
      var items = List<OrderItem>();
      if (types == null) {
        return chartData;
      }
      types.forEach((v) {
        OrderItem item = handleChartItemValue(indexModel, v);
        items.add(item);
      });

      var bbb = charts.Series<OrderItem, String>(
          id: indexModel.name,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (OrderItem sales, _) => sales.desc,
          measureFn: (OrderItem sales, _) => sales.count,
          data: items);
      chartData.add(bbb);

      return chartData;
    }).toList();

    return values;
  }

  List<List<charts.Series>> getSellChannelDatas(final datas) {
    var values = choice.indexList.map((indexModel) {
      var chartData = List<charts.Series<OrderItem, String>>();

      var items = List<OrderItem>();
      datas.data.forEach((v) {
        OrderItem item = handleChartItemValue(indexModel, v);
        items.add(item);
      });

      var bbb = charts.Series<OrderItem, String>(
          id: indexModel.name,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrderItem sales, _) => sales.desc,
          measureFn: (OrderItem sales, _) => sales.count,
          data: items);
      chartData.add(bbb);
      return chartData;
    }).toList();

    return values;
  }

  List<List<charts.Series>> getOrderChartDatas(final datas) {
    var values = choice.indexList.map((indexModel) {
      switch (transformMenuItemNameType(indexModel.name)) {
        case DetailMenuItemType.order_num:
          var chartData = List<charts.Series<OrderItem, String>>();
          var items1 = List<OrderItem>();
          var items2 = List<OrderItem>();
          datas.data.forEach((v) {
            OrderItem item = handleChartItemValue(indexModel, v);
            items1.add(item);
            items2.add(item);
          });

          var c1 = charts.Series<OrderItem, String>(
              id: "有效订单",
              colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
              domainFn: (OrderItem sales, _) =>
                  formatDate(DateTime.parse(sales.date), [mm, '.', dd]),
              measureFn: (OrderItem sales, _) => sales.ext,
              data: items2);

          var c2 = charts.Series<OrderItem, String>(
              id: "无效订单",
              colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
              domainFn: (OrderItem sales, _) =>
                  formatDate(DateTime.parse(sales.date), [mm, '.', dd]),
              measureFn: (OrderItem sales, _) => sales.count,
              data: items1);
          chartData.add(c1);
          chartData.add(c2);

          return chartData;
        default:
          var chartData = List<charts.Series<OrderItem, DateTime>>();
          var items = List<OrderItem>();
          datas.data.forEach((v) {
            OrderItem item = handleChartItemValue(indexModel, v);
            items.add(item);
          });
          var bbb = charts.Series<OrderItem, DateTime>(
              id: indexModel.name,
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (OrderItem sales, _) => DateTime.parse(sales.date),
              measureFn: (OrderItem sales, _) => sales.count,
              data: items);
          chartData.add(bbb);
          return chartData;
      }
    }).toList();

    return values;
  }

  OrderItem handleChartItemValue(IndexList model, final data) {
    switch (transformMenuItemNameType(model.name)) {
      case DetailMenuItemType.order_num:
        OrderChartData v = data;
        OrderItem item = OrderItem(
            count: v.value.notEffectOrderNum,
            ext: v.value.effectOrderNum,
            desc: v.date,
            date: v.date);
        return item;
      case DetailMenuItemType.room_night_count:
        OrderChartData v = data;
        OrderItem item = OrderItem(
            count: v.value.roomNightCount, desc: model.title, date: v.date);
        return item;
      case DetailMenuItemType.order_amount:
        OrderChartData v = data;
        OrderItem item = OrderItem(
            count: v.value.amount.toInt(), desc: model.title, date: v.date);
        return item;
      case DetailMenuItemType.cancel_order_list:
        OrderReasonNums v = data;
        OrderItem item = OrderItem(count: v.num, desc: v.date, date: v.date);
        return item;
      case DetailMenuItemType.cancel_reason_num:
        OrderReasonTypes v = data;
        OrderItem item = OrderItem(
            count: v.num, desc: v.percent.toString() + '% \n' + v.type, date: v.type);
        return item;
      case DetailMenuItemType.sell_channel:
        SellChannelData v = data;
        OrderItem item = OrderItem(
            count: v.number, desc: v.percent.toString()+'% \n'+v.sellChannel, date: v.sellChannel);
        return item;
      case DetailMenuItemType.other:
        OrderChartData v = data;
        OrderItem item = OrderItem(
            count: v.value.amount.toInt(), desc: v.date, date: v.date);
        return item;
      default:
        OrderChartData v = data;
        OrderItem item = OrderItem(
            count: v.value.amount.toInt(), desc: v.date, date: v.date);
        return item;
    }
  }
}
