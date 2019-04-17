import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class MaturityDescription extends StatelessWidget {
  MaturityDescription({@required this.maturity, Key key})
      : assert(maturity != null),
        super(key: key);

  final double maturity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Maturity",
          style: SarakaTextStyles.body2.apply(fontWeightDelta: 1),
        ),
        SizedBox(height: 4),
        Text(
          "${(maturity * 100).toStringAsFixed(2)}%",
          style: SarakaTextStyles.body2,
        ),
      ],
    );
  }
}
