import 'package:flutter/widgets.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class NextStudyDateText extends StatelessWidget {
  NextStudyDateText({@required this.card, Key key})
      : assert(card != null),
        super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    final difference = card.nextStudyScheduledAt.difference(DateTime.now());
    String when;

    if (difference.inHours <= 3) {
      when = "Soon";
    } else if (difference.inDays < 1) {
      when = "Today";
    } else if (difference.inDays < 14) {
      when = "${difference.inDays} days later";
    } else if (difference.inDays < 180) {
      when = "${difference.inDays ~/ 30} months later";
    } else {
      when = "in ${card.nextStudyScheduledAt.year}";
    }

    return Text(
      when,
      style: TextStyle(
        color: SarakaColors.darkGray,
        fontFamily: SarakaFonts.rubik,
      ),
    );
  }
}
