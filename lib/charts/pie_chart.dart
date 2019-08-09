import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieChartView extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PieChartView(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 90,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
      ),
    );
  }
}
