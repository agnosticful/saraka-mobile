import 'package:flutter/widgets.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class Maturity extends StatelessWidget {
  Maturity({@required this.card, Key key})
      : assert(card != null),
        super(key: key);

  final Card card;

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
          "${card.maturity.toStringAsFixed(2)}%",
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
