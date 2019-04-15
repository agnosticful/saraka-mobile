import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class IntroductionNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionSlider(
      children: [
        Container(
          decoration: BoxDecoration(
            color: SarakaColors.lightBlack,
          ),
          child: Center(
            child: Text("Get used to"),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: SarakaColors.darkRed,
          ),
          child: Center(
            child: Text("Get used to"),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: SarakaColors.darkRed,
          ),
          child: Center(
            child: Text("Get used to"),
          ),
        ),
      ],
    );
  }
}
