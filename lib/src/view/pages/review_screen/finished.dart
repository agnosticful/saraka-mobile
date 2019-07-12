import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';

class Finished extends StatefulWidget {
  @override
  _FinishedState createState() => _FinishedState();
}

class _FinishedState extends State<Finished> {
  final FlareControls _controls = FlareControls();

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final cardReviewBloc = Provider.of<CardReviewBloc>(context);

      _subscription = cardReviewBloc.isFinished.listen((isFinished) {
        if (isFinished) {
          _controls.play("main");
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: FlareActor(
                'assets/flare/done.flr',
                controller: _controls,
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: 'main',
              ),
            ),
            Text(
              "Well Done!",
              style: TextStyle(
                color: SarakaColors.darkWhite,
                fontSize: 24,
                fontFamily: SarakaFonts.rubik,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You finished all cards to do.\nSee you later!",
              style: TextStyle(
                color: SarakaColors.lightGray,
                fontSize: 16,
                fontFamily: SarakaFonts.rubik,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}
