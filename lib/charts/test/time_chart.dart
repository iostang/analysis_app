import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DateTimeComboLinePointChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DateTimeComboLinePointChart(this.seriesList, {this.animate});

  factory DateTimeComboLinePointChart.withSampleData() {
    return DateTimeComboLinePointChart(
      _createSampleData(),
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(),
      customSeriesRenderers: [
        charts.PointRendererConfig(
            customRendererId: 'customPoint')
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final desktopSalesData = [
      TimeSeriesSales(DateTime(2017, 7, 9), 5),
      TimeSeriesSales(DateTime(2018, 2, 16), 25),
      TimeSeriesSales(DateTime(2019, 1, 23), 100),
      TimeSeriesSales(DateTime(2020, 4, 10), 175),
    ];

    final tableSalesData = [
      TimeSeriesSales(DateTime(2017, 1, 19), 10),
      TimeSeriesSales(DateTime(2018, 6, 26), 50),
      TimeSeriesSales(DateTime(2019, 9, 31), 200),
      TimeSeriesSales(DateTime(2020, 10, 20), 150),
    ];

    final mobileSalesData = [
      TimeSeriesSales(DateTime(2017, 9, 19), 10),
      TimeSeriesSales(DateTime(2018, 6, 26), 50),
      TimeSeriesSales(DateTime(2019, 1, 3), 200),
      TimeSeriesSales(DateTime(2020, 10, 10), 150),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: mobileSalesData)
        // ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}


class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}