import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './card_list_button.dart';
import './card_maturity_donut_chart.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<CardListBloc>(
        builder: (context, cardListBloc) => StreamBuilder<List<Card>>(
              stream: cardListBloc.cards.map((iter) => iter.toList()),
              initialData: [],
              builder: (context, snapshot) => AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CardMaturityDonutChart(
                          seriesList: <charts.Series<MatureCount, int>>[
                            charts.Series(
                              id: 'CardMaturity',
                              domainFn: (MatureCount matures, _) =>
                                  matures.maturity,
                              measureFn: (MatureCount matures, _) =>
                                  matures.maturity,
                              colorFn: (MatureCount matures, i) =>
                                  matures.color,
                              data: [
                                new MatureCount(
                                    "Mature",
                                    snapshot.requireData
                                        .where((card) =>
                                            card.maturity * 100 >= 100)
                                        .toList()
                                        .length,
                                    SarakaColors.lightRed),
                                new MatureCount(
                                  "Immature",
                                  snapshot.requireData
                                      .where(
                                          (card) => card.maturity * 100 < 100)
                                      .toList()
                                      .length,
                                  SarakaColors.darkGray.withOpacity(0.2),
                                ),
                              ],
                              outsideLabelStyleAccessorFn:
                                  (MatureCount row, _) => charts.TextStyleSpec(
                                      color: charts.MaterialPalette.black),
                            ),
                          ],
                          animate: true,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _calculateMatureCardRate(
                                              snapshot.requireData) ==
                                          100
                                      ? 100.toString()
                                      : _calculateMatureCardRate(
                                              snapshot.requireData)
                                          .toStringAsFixed(1),
                                  overflow: TextOverflow.ellipsis,
                                  style: SarakaTextStyles.heading
                                      .copyWith(fontSize: 64),
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
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        color: SarakaColors.lightRed,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    Text(
                                      "Mature",
                                      overflow: TextOverflow.ellipsis,
                                      style: SarakaTextStyles.body2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        color: SarakaColors.darkGray
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    Text(
                                      "Immature",
                                      overflow: TextOverflow.ellipsis,
                                      style: SarakaTextStyles.body2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            CardListButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
            ),
      );

  double _calculateMatureCardRate(List<Card> cards) =>
      cards.where((card) => card.maturity * 100 >= 100).toList().length /
      cards.length *
      100;
}
