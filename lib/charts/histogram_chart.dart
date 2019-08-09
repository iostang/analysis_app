import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:analysis_app/model/order_reason_model.dart';
import 'package:analysis_app/tools/toast.dart';

class HistogramChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HistogramChart(this.seriesList, {this.animate});

  @override
  State<StatefulWidget> createState() => new _HidtogramChartState();

}

class _HidtogramChartState extends State<HistogramChart> {

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
          widget.seriesList,
          animate: widget.animate,
          barGroupingType: charts.BarGroupingType.grouped,
          behaviors: [new charts.SeriesLegend()],
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
            measures["date"] = datumPair.datum.desc;
            measures["ext"] = datumPair.datum.ext;
            measures["count"] = datumPair.datum.count;
        }
        
      });
    }
    String count = measures['count'].toString();
    String ext = measures['ext'].toString();
    String date = measures['date'].toString();
    String toast = "日期: $date\n有效订单: $ext"+'\n'+"无效订单: $count";
    TjToast.show(toast);
  }
}