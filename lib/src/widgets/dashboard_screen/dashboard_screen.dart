import 'package:flutter/material.dart' hide AppBar, Card;
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './app_bar.dart';
import './main_drawer/main_drawer.dart';
import './proficient_card_prediction_text.dart';
import './ready_card_length_text.dart';
import './start_learning_floating_action_button.dart';
import './summary.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveBackground(color: SarakaColors.white),
          Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Color(0x00000000),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: StartLearningFloatingActionButton(),
            appBar: AppBar(),
            drawer: MainDrawer(),
            body: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 280,
                                  minHeight: 280,
                                  maxWidth: 280,
                                  maxHeight: 280,
                                ),
                                child: Summary(),
                              ),
                              SizedBox(height: 16),
                              ProficientCardPredictionText(),
                            ],
                          ),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: ReadyCardLengthText(),
                ),
              ],
            ),
          ),
        ],
      );
}
