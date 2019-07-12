import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class NextReviewDateDescription extends StatelessWidget {
  NextReviewDateDescription({@required this.nextReviewScheduledAt, Key key})
      : assert(nextReviewScheduledAt != null),
        super(key: key);

  final DateTime nextReviewScheduledAt;

  @override
  Widget build(BuildContext context) {
    final difference = nextReviewScheduledAt.difference(DateTime.now());
    String when;

    if (difference.inHours <= 3) {
      when = "Soon";
    } else if (difference.inDays < 1) {
      when = "Today";
    } else if (difference.inDays == 1) {
      when = "Tomorrow";
    } else if (difference.inDays < 30) {
      when = "${difference.inDays} days later";
    } else if (difference.inDays < 180) {
      when = "${difference.inDays ~/ 30} months later";
    } else {
      when = "in ${nextReviewScheduledAt.year}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Next Review",
          style: SarakaTextStyles.body2.apply(fontWeightDelta: 1),
        ),
        SizedBox(height: 4),
        Text(
          when,
          style: SarakaTextStyles.body2,
        ),
      ],
    );
  }
}
