import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class ProficiencyDescription extends StatelessWidget {
  ProficiencyDescription({@required this.proficiency, Key key})
      : assert(proficiency != null),
        super(key: key);

  final double proficiency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Proficiency",
          style: SarakaTextStyle.body2,
        ),
        SizedBox(height: 4),
        Text(
          "${(proficiency * 100).toStringAsFixed(2)}%",
          style: SarakaTextStyle.body2,
        ),
      ],
    );
  }
}
