import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveBackground extends StatelessWidget {
  WaveBackground({Key key, @required this.color})
      : assert(color != null),
        super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    final isColorDark = this.color.computeLuminance() < 0.5;
    final interpolateTargetColor =
        isColorDark ? SarakaColor.white : SarakaColor.darkBlack;
    final color1 = isColorDark
        ? Color.lerp(this.color, interpolateTargetColor, .25)
        : this.color;
    final color2 = isColorDark
        ? Color.lerp(this.color, interpolateTargetColor, .28125)
        : Color.lerp(this.color, interpolateTargetColor, .03125);
    final color3 = isColorDark
        ? Color.lerp(this.color, interpolateTargetColor, .03125)
        : Color.lerp(this.color, interpolateTargetColor, .0625);
    final color4 = isColorDark
        ? Color.lerp(this.color, interpolateTargetColor, .25)
        : Color.lerp(this.color, interpolateTargetColor, .09375);
    final color5 = isColorDark
        ? this.color
        : Color.lerp(this.color, interpolateTargetColor, .125);

    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [color3, color2],
          [color5, color4],
        ],
        durations: [10860, 19440],
        heightPercentages: [0.2, 0.5],
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      backgroundColor: color1,
      size: Size.infinite,
      waveAmplitude: 0,
    );
  }
}
