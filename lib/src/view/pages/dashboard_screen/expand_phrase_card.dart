import 'package:flutter/material.dart' show Material;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class ExpandPhraseCard extends StatelessWidget {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/card-writing.png",
                    width: 64,
                    height: 64,
                  ),
                  SizedBox(width: 16),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expand your phrases",
                          style: SarakaTextStyles.body.apply(
                            color: SarakaColors.darkBlack,
                          ),
                        ),
                        SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: SarakaColors.darkGray,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Phrases you heard today",
                                  style: SarakaTextStyles.body2,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: SarakaColors.darkGray,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Phrases related on your job or major",
                                  style: SarakaTextStyles.body2,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(),
                                    color: SarakaColors.darkGray,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Useful phrases at cafe or restaurants",
                                  style: SarakaTextStyles.body2,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProcessableFancyButton(
                    child: Text("Add New"),
                    color: SarakaColors.lightRed,
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/cards:new"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
