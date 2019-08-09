import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class IntegerOnlyMeasureAxis extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  IntegerOnlyMeasureAxis(this.seriesList, {this.animate});

  factory IntegerOnlyMeasureAxis.withSampleData() {
    return IntegerOnlyMeasureAxis(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
            dataIsInWholeNumbers: true, desiredTickCount: 7),
      ),
    );
  }

  static List<charts.Series<DateRow, DateTime>> _createSampleData() {
    final data = [
      DateRow(DateTime(2017, 9, 25), 0),
      DateRow(DateTime(2018, 9, 26), 0),
      DateRow(DateTime(2019, 9, 27), 0),
      DateRow(DateTime(2020, 9, 28), 6),
      DateRow(DateTime(2021, 9, 29), 2),
      DateRow(DateTime(2022, 9, 30), 6),
      DateRow(DateTime(2023, 10, 01), 1),
      DateRow(DateTime(2024, 10, 02), 7),
      DateRow(DateTime(2025, 10, 03), 5),
      DateRow(DateTime(2026, 10, 04), 3),
      DateRow(DateTime(2027, 10, 05), 1),
    ];

    return [
      charts.Series<DateRow, DateTime>(
        id: 'Headcount',
        domainFn: (DateRow row, _) => row.timeStamp,
        measureFn: (DateRow row, _) => row.headcount,
        data: data,
      )
    ];
  }
}

class DateRow {
  final DateTime timeStamp;
  final int headcount;
  DateRow(this.timeStamp, this.headcount);
}
