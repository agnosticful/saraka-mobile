import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class ProgressIndicator extends StatefulWidget {
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
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
  Widget build(BuildContext context) => SizedBox(
        height: 2,
        child: _cardStudyingBloc == null
            ? LinearProgressIndicator(
                value: 0,
                backgroundColor: SarakaColors.darkGray,
                valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
              )
            : StreamBuilder<double>(
                stream: _cardStudyingBloc.finishedRatio,
                initialData: 0,
                builder: (context, snapshot) => LinearProgressIndicator(
                      value: snapshot.requireData,
                      backgroundColor: SarakaColors.darkGray,
                      valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
                    ),
              ),
      );
}
