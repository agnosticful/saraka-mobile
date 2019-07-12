import 'package:flutter/material.dart' hide AppBar, Card;
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './dashboard_screen/app_bar.dart';
import './dashboard_screen/main_drawer/main_drawer.dart';
import './dashboard_screen/next_review_card.dart';
import './dashboard_screen/expand_phrase_card.dart';
import './dashboard_screen/progress_card.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveBackground(color: SarakaColors.white),
          SafeArea(
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Color(0x00000000),
              appBar: AppBar(),
              drawer: MainDrawer(),
              body: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  ExpandPhraseCard(),
                  SizedBox(height: 16),
                  ProgressCard(),
                  SizedBox(height: 16),
                  NextReviewCard(),
                ],
              ),
            ),
          ),
        ],
      );
}
