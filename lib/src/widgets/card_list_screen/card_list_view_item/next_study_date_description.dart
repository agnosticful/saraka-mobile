import 'package:flutter/widgets.dart';
import 'package:saraka/constants.dart';

class NextStudyDateDescription extends StatelessWidget {
  NextStudyDateDescription({@required this.nextStudyScheduledAt, Key key})
      : assert(nextStudyScheduledAt != null),
        super(key: key);

  final DateTime nextStudyScheduledAt;

  @override
  Widget build(BuildContext context) {
    final difference = nextStudyScheduledAt.difference(DateTime.now());
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
      when = "in ${nextStudyScheduledAt.year}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Next Study",
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
