import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class TimeEstimation extends StatefulWidget {
  State<TimeEstimation> createState() => _TimeEstimationState();
}

class _TimeEstimationState extends State<TimeEstimation> {
  CardStudyBloc _cardStudyingBloc;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final cardStudyingBloc = Provider.of<CardStudyBloc>(context);

      setState(() {
        _cardStudyingBloc = cardStudyingBloc;
      });
    });
  }

  @override
  Widget build(BuildContext context) => _cardStudyingBloc == null
      ? Text("")
      : StreamBuilder<Iterable<Card>>(
          stream: _cardStudyingBloc.cardsInQueue,
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

    return Text(
      text,
      style: TextStyle(
        color: SarakaColors.white,
        fontFamily: SarakaFonts.rubik,
        fontSize: 16,
      ),
    );
  }
}
