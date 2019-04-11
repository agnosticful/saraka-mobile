import 'package:flutter/material.dart';
import 'package:saraka/constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
 
class WaveBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
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
    );
  }
}
