import 'package:flutter/material.dart' hide Card;
import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import '../../widgets/processable_fancy_button.dart';

class NextReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Material(
        elevation: 16,
        shadowColor: SarakaColor.lightBlack.withOpacity(0.1),
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
                    "assets/images/hourglass.png",
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
                          "Come here 16 hours later",
                          style: SarakaTextStyle.heading,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "You'll review 17 phrases (3 mins taken)",
                          style: SarakaTextStyle.body2,
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
                    child: Text("Review Phrases"),
                    color: SarakaColor.lightRed,
                    onPressed: () => Navigator.of(context).pushNamed("/review"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
