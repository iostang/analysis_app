import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OrdinalComboBarLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  OrdinalComboBarLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.OrdinalComboChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped),
        customSeriesRenderers: [
          new charts.LineRendererConfig(
              customRendererId: 'customLine')
        ]);
  }
  
}
