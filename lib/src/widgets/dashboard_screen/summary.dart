import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../blocs/card_list_bloc.dart';
import './card_list_button.dart';
import './card_proficiency_donut_chart.dart';

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
                        CardProficiencyDonutChart(
                          seriesList: <charts.Series<ProficientCount, int>>[
                            charts.Series(
                              id: 'CardProficiency',
                              domainFn: (ProficientCount proficients, _) =>
                                  proficients.proficiency,
                              measureFn: (ProficientCount proficients, _) =>
                                  proficients.proficiency,
                              colorFn: (ProficientCount proficients, i) =>
                                  proficients.color,
                              data: [
                                new ProficientCount(
                                    "Familiar",
                                    snapshot.requireData
                                        .where((card) =>
                                            card.proficiency * 100 >= 100)
                                        .toList()
                                        .length,
                                    SarakaColors.lightRed),
                                new ProficientCount(
                                  "Need to study",
                                  snapshot.requireData
                                      .where((card) =>
                                          card.proficiency * 100 < 100)
                                      .toList()
                                      .length,
                                  SarakaColors.darkGray.withOpacity(0.2),
                                ),
                              ],
                              outsideLabelStyleAccessorFn:
                                  (ProficientCount row, _) =>
                                      charts.TextStyleSpec(
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
                                  _calculateProficientCardRate(
                                              snapshot.requireData) ==
                                          100
                                      ? 100.toString()
                                      : _calculateProficientCardRate(
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
                                      "Familiar",
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
                                      "Need to study",
                                      overflow: TextOverflow.ellipsis,
                                      style: SarakaTextStyles.body2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            CardListButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
            ),
      );

  double _calculateProficientCardRate(List<Card> cards) =>
      cards.where((card) => card.proficiency * 100 >= 100).toList().length /
      cards.length *
      100;
}
