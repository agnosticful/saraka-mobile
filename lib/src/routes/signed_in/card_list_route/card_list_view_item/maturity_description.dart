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
          style: const TextStyle(
            color: SarakaColors.darkGray,
            fontFamily: SarakaFonts.rubik,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "${maturity.toStringAsFixed(2)}%",
          style: TextStyle(
            color: SarakaColors.darkGray,
            fontFamily: SarakaFonts.rubik,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
