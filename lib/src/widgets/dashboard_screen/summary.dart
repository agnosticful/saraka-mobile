import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
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

  double getMatureCardRatio() =>
      cardsMaturity
          .where((iter) => iter.maturity * 100 >= 100)
          .toList()
          .length /
      totalCardsNumber *
      100;

  List getNextMatureCards() => cardsMaturity
      .where((iter) =>
          iter.nextReviewInterval <= const Duration(days: 7) &&
          iter.nextReviewInterval * iter.modifier >= const Duration(days: 365))
      .toList();

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
                                  SarakaColors.lightRed),
                              new MatureCount(
                                "Immature",
                                cardsMaturity
                                    .where((iter) => iter.maturity * 100 < 100)
                                    .toList()
                                    .length,
                                SarakaColors.darkGray.withOpacity(0.2),
                              ),
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
                              getMatureCardRatio() == 100
                                  ? 100.toString()
                                  : getMatureCardRatio().toStringAsFixed(1),
                              overflow: TextOverflow.ellipsis,
                              style: SarakaTextStyles.heading
                                  .copyWith(fontSize: 48),
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                Text(
                                  '%',
                                  overflow: TextOverflow.ellipsis,
                                  style: SarakaTextStyles.heading
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
                            Container(
                              height: 8,
                              width: 8,
                              decoration: ShapeDecoration(
                                shape: SuperellipseShape(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: SarakaColors.lightRed,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3),
                            ),
                            Text(
                              "Mature",
                              overflow: TextOverflow.ellipsis,
                              style: SarakaTextStyles.body,
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
                              padding: EdgeInsets.only(right: 21),
                            ),
                            Container(
                              height: 8,
                              width: 8,
                              decoration: ShapeDecoration(
                                shape: SuperellipseShape(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: SarakaColors.darkGray.withOpacity(0.2),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 3),
                            ),
                            Text(
                              "Immature",
                              overflow: TextOverflow.ellipsis,
                              style: SarakaTextStyles.body,
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
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: SuperellipseShape(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        width: 240,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'SEE ALL ' +
                                  totalCardsNumber.toString() +
                                  ' CARDS',
                              overflow: TextOverflow.ellipsis,
                              style: SarakaTextStyles.heading.copyWith(
                                fontSize: 20,
                                color: SarakaColors.darkGray,
                              ),
                            ),
                            Icon(
                              Feather.getIconData('arrow-right-circle'),
                              color: SarakaColors.darkGray,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/cards'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      getNextMatureCards().length.toString() +
                          ' cards will be mature',
                      overflow: TextOverflow.ellipsis,
                      style: SarakaTextStyles.body,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 48),
                        ),
                        Text(
                          'within 7 days to come',
                          overflow: TextOverflow.ellipsis,
                          style: SarakaTextStyles.body,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 80),
            child: Text(
              todayLearnNumber + ' cards you will study today',
              overflow: TextOverflow.ellipsis,
              style: SarakaTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
}
