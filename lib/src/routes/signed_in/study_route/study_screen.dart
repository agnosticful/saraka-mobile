import 'package:flutter/material.dart' show AppBar, IconButton, Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import './back_button.dart';
import './card_bundle.dart';
import './progress_indicator.dart';

class StudyScreen extends StatefulWidget {
  StudyScreen({Key key}) : super(key: key);

  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [
                  SarakaColors.lightBlack,
                  SarakaColors.darkBlack,
                ],
                [
                  SarakaColors.darkBlack.withOpacity(0.5),
                  SarakaColors.darkBlack.withOpacity(0.75),
                ],
              ],
              durations: [19440, 6000],
              heightPercentages: [0.2, 0.5],
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            backgroundColor: SarakaColors.lightBlack,
            size: Size.infinite,
            waveAmplitude: 0,
          ),
          Scaffold(
            backgroundColor: Color(0x00000000),
            appBar: AppBar(
              title: Text(
                'Study',
                style: TextStyle(
                  color: SarakaColors.white,
                  fontFamily: SarakaFonts.rubik,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0x00000000),
              elevation: 0,
              iconTheme: IconThemeData(color: SarakaColors.white),
              actions: [
                IconButton(
                  icon: Icon(Feather.getIconData('inbox')),
                  onPressed: () => Navigator.of(context).pushNamed('/cards'),
                ),
              ],
            ),
            body: Column(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          CardBundle(),
        ],
      );
}
