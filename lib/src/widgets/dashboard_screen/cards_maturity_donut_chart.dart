import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CardsMaturityDonutChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  CardsMaturityDonutChart({@required this.seriesList, @required this.animate})
      : assert(seriesList != null),
        assert(animate != null);

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 10,
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }
}

class MatureCount {
  final String title;
  final int maturity;

  MatureCount(this.title, this.maturity);
}
