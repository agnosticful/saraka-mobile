import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import './card_maturity_donut_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Summary extends StatelessWidget {
  Summary({this.totalCardsNumber, this.todayLearnNumber, this.cardsMaturity})
      : assert(totalCardsNumber != null),
        assert(todayLearnNumber != null),
        assert(cardsMaturity != null);

  final int totalCardsNumber;

  final String todayLearnNumber;

  final List cardsMaturity;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 280.0,
                      width: 280.0,
                      child: CardMaturityDonutChart(
                        seriesList: <charts.Series<MatureCount, int>>[
                          charts.Series(
                            id: 'CardMaturity',
                            domainFn: (MatureCount matures, _) =>
                                matures.maturity,
                            measureFn: (MatureCount matures, _) =>
                                matures.maturity,
                            colorFn: (MatureCount matures, i) => matures.color,
                            data: [
                              new MatureCount(
                                  "Mature",
                                  cardsMaturity
                                      .where(
                                          (iter) => iter.maturity * 100 >= 100)
                                      .toList()
                                      .length,
                                  SarakaColors.lightYellow),
                              new MatureCount(
                                  "Immature",
                                  cardsMaturity
                                      .where(
                                          (iter) => iter.maturity * 100 < 100)
                                      .toList()
                                      .length,
                                  SarakaColors.lightRed),
                            ],
                            outsideLabelStyleAccessorFn: (MatureCount row, _) =>
                                charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black),
                          ),
                        ],
                        animate: true,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              ((cardsMaturity
                                              .where((iter) =>
                                                  iter.maturity * 100 >= 100)
                                              .toList()
                                              .length /
                                          totalCardsNumber) *
                                      100)
                                  .toStringAsFixed(2)
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              style:
                                  SarakaTextStyles.body.copyWith(fontSize: 48),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 24),
                                ),
                                Text(
                                  '%',
                                  overflow: TextOverflow.ellipsis,
                                  style: SarakaTextStyles.body2
                                      .copyWith(fontSize: 24),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 24),
                            ),
                            Icon(
                              Icons.fiber_manual_record,
                              size: 12,
                              color: SarakaColors.lightYellow,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3),
                            ),
                            Text(
                              "Mature",
                              overflow: TextOverflow.ellipsis,
                              style:
                                  SarakaTextStyles.body2.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 38),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 24),
                            ),
                            Icon(
                              Icons.fiber_manual_record,
                              size: 12,
                              color: SarakaColors.lightRed,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3),
                            ),
                            Text(
                              "Immature",
                              overflow: TextOverflow.ellipsis,
                              style:
                                  SarakaTextStyles.body2.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'See all ' + totalCardsNumber.toString() + ' cards',
                          overflow: TextOverflow.ellipsis,
                          style: SarakaTextStyles.body.copyWith(fontSize: 24),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: SarakaColors.darkGray,
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/cards'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 80),
            child: Text(
              todayLearnNumber + ' cards you study for today',
              overflow: TextOverflow.ellipsis,
              style: SarakaTextStyles.body.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}
