/// Time series chart with line annotation example
///
/// The example future range annotation extends beyond the range of the series
/// data, demonstrating the effect of the [Charts.RangeAnnotation.extendAxis]
/// flag. This can be set to false to disable range extension.
///
/// Additional annotations may be added simply by adding additional
/// [Charts.RangeAnnotationSegment] items to the list.
//import 'package:charts_flutter/flutter.dart' as charts;
/*import 'package:flutter/material.dart';

class TimeSeriesLineAnnotationChart extends StatelessWidget {
  //final List<charts.Series> seriesList;
  final bool animate;

  //TimeSeriesLineAnnotationChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  /*factory TimeSeriesLineAnnotationChart.withSampleData() {
    return new TimeSeriesLineAnnotationChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );*/
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList, animate: animate, behaviors: [
      new charts.RangeAnnotation([
        new charts.LineAnnotationSegment(
            new DateTime(2019, 06, 4), charts.RangeAnnotationAxisType.domain,
            startLabel: 'Junio 04'),
        new charts.LineAnnotationSegment(
            new DateTime(2019, 06, 15), charts.RangeAnnotationAxisType.domain,
            endLabel: 'Junio 15'),
      ]),
    ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2019, 6, 4), 1000),
      new TimeSeriesSales(new DateTime(2019, 6, 5), 1000),
      new TimeSeriesSales(new DateTime(2019, 6, 6), 1000),
      new TimeSeriesSales(new DateTime(2019, 6, 7), 1000),
      new TimeSeriesSales(new DateTime(2019, 6, 8), 4000),
      new TimeSeriesSales(new DateTime(2019, 6, 9), 5500),
      new TimeSeriesSales(new DateTime(2019, 6, 10), 2200),
      new TimeSeriesSales(new DateTime(2019, 6, 11), 1200),
      new TimeSeriesSales(new DateTime(2019, 6, 12), 2450),
      new TimeSeriesSales(new DateTime(2019, 6, 13), 1230),
      new TimeSeriesSales(new DateTime(2019, 6, 14), 1200),
      new TimeSeriesSales(new DateTime(2019, 6, 15), 2000),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}*/