import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:analysis_app/model/order_reason_model.dart';
import 'package:analysis_app/tools/toast.dart';

class BrokenChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BrokenChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(zeroBound: false),
      ),
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener:_onSelectionChanged,
        )
      ],
    );
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

      final measures = <String, dynamic>{};
    if (selectedDatum.isNotEmpty) {
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        if (datumPair.datum is OrderItem) {
            measures["date"] = datumPair.datum.date;
            measures["title"] = datumPair.datum.desc;
            measures["count"] = datumPair.datum.count;
        }
        
      });
    }
    String count = measures['count'].toString();
    String title = measures['title'].toString();
    String date = measures['date'].toString();
    String toast = "日期: $date\n$title: $count";
    TjToast.show(toast);

  }

}
