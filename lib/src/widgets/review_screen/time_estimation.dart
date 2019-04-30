import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_review_bloc.dart';

class TimeEstimation extends StatefulWidget {
  State<TimeEstimation> createState() => _TimeEstimationState();
}

class _TimeEstimationState extends State<TimeEstimation> {
  CardReviewBloc _cardReviewingBloc;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final cardReviewingBloc = Provider.of<CardReviewBloc>(context);

      setState(() {
        _cardReviewingBloc = cardReviewingBloc;
      });
    });
  }

  @override
  Widget build(BuildContext context) => _cardReviewingBloc == null
      ? Text("")
      : StreamBuilder<Iterable<Card>>(
          stream: _cardReviewingBloc.cardsInQueue,
          initialData: Iterable.empty(),
          builder: (context, snapshot) => _TimeEstimationText(
                duration:
                    Duration(milliseconds: snapshot.requireData.length * 7500),
              ),
        );
}

class _TimeEstimationText extends StatelessWidget {
  _TimeEstimationText({@required Duration duration, Key key})
      : assert(duration != null),
        _duration = duration,
        super(key: key);

  final Duration _duration;

  @override
  Widget build(BuildContext context) {
    final text = _duration.inMilliseconds == 0
        ? "finished"
        : _duration.inMinutes >= 1
            ? "in ${_duration.inMinutes} mins"
            : "in < 1 mins";

    return Text(text, style: SarakaTextStyles.body);
  }
}
