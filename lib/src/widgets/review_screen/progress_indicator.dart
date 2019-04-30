import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_review_bloc.dart';

class ProgressIndicator extends StatefulWidget {
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
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
  Widget build(BuildContext context) => SizedBox(
        height: 2,
        child: _cardReviewingBloc == null
            ? LinearProgressIndicator(
                value: 0,
                backgroundColor: SarakaColors.darkGray,
                valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
              )
            : StreamBuilder<double>(
                stream: _cardReviewingBloc.finishedRatio,
                initialData: 0,
                builder: (context, snapshot) => LinearProgressIndicator(
                      value: snapshot.requireData,
                      backgroundColor: SarakaColors.darkGray,
                      valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
                    ),
              ),
      );
}
