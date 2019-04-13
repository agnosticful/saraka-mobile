import 'package:flutter/material.dart' show AppBar, IconButton, Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';
import './back_button.dart';
import './card_bundle.dart';
import './finished.dart';
import './progress_indicator.dart';
import './time_estimation.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveBackground(color: SarakaColors.darkBlack),
          Scaffold(
            backgroundColor: Color(0x00000000),
            appBar: AppBar(
              title: Text(
                'Review',
                style: SarakaTextStyles.appBarTitle,
              ),
              centerTitle: true,
              backgroundColor: Color(0x00000000),
              elevation: 0,
              leading: Navigator.of(context).canPop()
                  ? IconButton(
                      icon: Icon(Feather.getIconData('arrow-left')),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BackButton(),
                          SizedBox(width: 16),
                          Expanded(
                            child: ProgressIndicator(),
                          ),
                          SizedBox(width: 16),
                          TimeEstimation(),
                        ],
                      ),
                    ),
                  ],
                ),
                Finished(),
                CardBundle(),
              ],
            ),
          ),
        ],
      );
}
