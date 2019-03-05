import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:saraka/constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class StudyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          WaveWidget(
            config: CustomConfig(
              gradients: [
                [
                  SarakaColors.lightGray.withOpacity(0.125),
                  SarakaColors.darkGray.withOpacity(0.125)
                ],
                [
                  SarakaColors.lightGray.withOpacity(0.25),
                  SarakaColors.darkGray.withOpacity(0.25)
                ],
              ],
              durations: [19440, 6000],
              heightPercentages: [0.2, 0.5],
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            backgroundColor: SarakaColors.white,
            size: Size.infinite,
            waveAmplitude: 0,
          ),
          Scaffold(
            backgroundColor: Color(0x00000000),
            appBar: AppBar(
              title: Text(
                'Study',
                style: TextStyle(
                  color: SarakaColors.lightBlack,
                  fontFamily: SarakaFonts.rubik,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0x00000000),
              elevation: 0,
              iconTheme: IconThemeData(color: SarakaColors.lightBlack),
              actions: [
                IconButton(
                  icon: Icon(Feather.getIconData('inbox')),
                  onPressed: () => Navigator.of(context).pushNamed('/cards'),
                ),
              ],
            ),
            body: Container(),
          ),
        ],
      );
}
