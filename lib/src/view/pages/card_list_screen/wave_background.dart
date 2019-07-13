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
            SarakaColor.lightGray.withOpacity(0.125),
            SarakaColor.darkGray.withOpacity(0.125)
          ],
          [
            SarakaColor.lightGray.withOpacity(0.25),
            SarakaColor.darkGray.withOpacity(0.25)
          ],
        ],
        durations: [19440, 6000],
        heightPercentages: [0.2, 0.5],
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      backgroundColor: SarakaColor.white,
      size: Size.infinite,
      waveAmplitude: 0,
    );
  }
}
