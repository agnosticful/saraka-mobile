import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CardsMaturityDonutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CardsMaturityDonutChart(this.seriesList, {this.animate});

  factory CardsMaturityDonutChart.withData(double maturity) {
    return new CardsMaturityDonutChart(
      _createData(maturity),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 10,
        arcRendererDecorators: [new charts.ArcLabelDecorator()]
        // TODO change font and line.
      )
    );
  }

  static List<charts.Series<LinearSales, double>> _createData(double maturity) {
    final data = [
      new LinearSales("Mature", maturity),
      new LinearSales("Immature", 100 - maturity),
    ];

    return [
      new charts.Series<LinearSales, double>(
        id: 'Maturity',
        domainFn: (LinearSales sales, _) => sales.maturity,
        measureFn: (LinearSales sales, _) => sales.maturity,
        data: data,
      )
    ];
  }
}

class LinearSales {
  final String title;
  final double maturity;

  LinearSales(this.title, this.maturity);
}