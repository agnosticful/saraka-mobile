import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/entities.dart';
import 'package:saraka/widgets.dart';

class ProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        elevation: 4,
        color: Color(0xffffffff),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/score-board.png",
                    width: 64,
                    height: 64,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phrases you mastered",
                            style: SarakaTextStyles.body.apply(
                              color: SarakaColors.darkBlack,
                            ),
                          ),
                          SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 4,
                                color: SarakaColors.lightGray,
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.2,
                                child: Container(
                                  height: 4,
                                  color: SarakaColors.lightRed,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "24 phrases",
                            style: SarakaTextStyles.body2,
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Phrases you'll master soon",
                            style: SarakaTextStyles.body.apply(
                              color: SarakaColors.darkBlack,
                            ),
                          ),
                          SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 4,
                                color: SarakaColors.lightGray,
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.2,
                                child: Container(
                                  height: 4,
                                  color: SarakaColors.darkGray,
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) => Padding(
                                      padding: EdgeInsets.only(
                                        left: constraints.maxWidth * 0.2,
                                      ),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.1,
                                        child: Container(
                                          height: 4,
                                          color: SarakaColors.lightRed,
                                        ),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "24 → 30 phrases",
                            style: SarakaTextStyles.body2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<CardListBloc>(
                    builder: (context, cardListBloc, _) =>
                        StreamBuilder<List<Card>>(
                          stream: cardListBloc.cards,
                          initialData: cardListBloc.cards.value,
                          builder: (context, snapshot) =>
                              ProcessableFancyButton(
                                isProcessing: !snapshot.hasData,
                                color: SarakaColors.darkWhite,
                                onPressed: () =>
                                    Navigator.of(context).pushNamed("/cards"),
                                child: snapshot.hasData
                                    ? Text(
                                        "Explore (${snapshot.requireData.length})")
                                    : Text("Explore"),
                              ),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
