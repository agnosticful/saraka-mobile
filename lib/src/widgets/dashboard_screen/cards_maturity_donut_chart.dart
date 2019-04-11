import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CardsMaturityDonutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CardsMaturityDonutChart(this.seriesList, {this.animate});

  factory CardsMaturityDonutChart.withData(List maturity) {
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
      )
    );
  }

  static List<charts.Series<MatureCount, int>> _createData(List maturity) {
    final data = [
      new MatureCount("80", maturity.where((iter) => iter.maturity >= 80).toList().length),
      new MatureCount("50", maturity.where((iter) => iter.maturity >= 50 && iter.maturity < 80).toList().length),
      new MatureCount("30", maturity.where((iter) => iter.maturity >= 30 && iter.maturity < 50).toList().length),
      new MatureCount("29", maturity.where((iter) => iter.maturity < 30).toList().length),
    ];

    return [
      new charts.Series<MatureCount, int>(
        id: 'Maturity',
        domainFn: (MatureCount matures, _) => matures.maturity,
        measureFn: (MatureCount matures, _) => matures.maturity,
        data: data,
      )
    ];
  }
}

class MatureCount {
  final String title;
  final int maturity;

  MatureCount(this.title, this.maturity);
}