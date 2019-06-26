import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../../blocs/card_review_bloc.dart';

class ProgressIndicator extends StatefulWidget {
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<CardReviewBloc>(
        builder: (context, cardReviewBloc, _) => SizedBox(
              height: 2,
              child: StreamBuilder<double>(
                stream: cardReviewBloc.finishedCardRatio,
                initialData: 0,
                builder: (context, snapshot) {
                  print(snapshot.requireData);

                  return LinearProgressIndicator(
                    value: snapshot.requireData,
                    backgroundColor: SarakaColors.darkGray,
                    valueColor: AlwaysStoppedAnimation(SarakaColors.lightRed),
                  );
                },
              ),
            ),
      );
}
