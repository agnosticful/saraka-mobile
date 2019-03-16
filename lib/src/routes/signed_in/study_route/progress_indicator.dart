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

  int _originalLength;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final cardStudyingBloc = Provider.of<CardStudyBloc>(context);

      setState(() {
        _cardStudyingBloc = cardStudyingBloc;
        _originalLength = 1000;
      });
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 2,
        child: _cardStudyingBloc == null || _originalLength == null
            ? LinearProgressIndicator(
                value: 0,
                backgroundColor: SarakaColors.darkGray,
                valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
              )
            : StreamBuilder<Iterable<Card>>(
                stream: _cardStudyingBloc.cards,
                initialData: [],
                builder: (context, snapshot) => LinearProgressIndicator(
                      value: (_originalLength - snapshot.requireData.length) /
                          _originalLength,
                      backgroundColor: SarakaColors.darkGray,
                      valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
                    ),
              ),
      );
}
