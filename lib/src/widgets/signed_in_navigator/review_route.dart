import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/card_review_bloc.dart';
import '../../blocs/synthesizer_bloc.dart';

class ReviewRoute extends MaterialPageRoute {
  ReviewRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => MultiProvider(
                providers: [
                  StatefulProvider<CardReviewBloc>(
                    valueBuilder: (_) =>
                        Provider.of<CardReviewBlocFactory>(context).create()
                          ..initialize(),
                  ),
                  StatefulProvider<SynthesizerBloc>(
                    valueBuilder: (_) =>
                        Provider.of<SynthesizerBlocFactory>(context).create(),
                  ),
                ],
                child: child,
              ),
          settings: settings,
        );
}
