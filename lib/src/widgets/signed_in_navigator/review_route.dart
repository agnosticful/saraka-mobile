import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/card_review_bloc.dart';
import '../../blocs/synthesizer_bloc.dart';

class ReviewRoute extends MaterialPageRoute {
  ReviewRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => Consumer3<AuthenticationBloc,
                  CardReviewBlocFactory, SynthesizerBlocFactory>(
                builder: (
                  context,
                  authenticationBloc,
                  cardReviewBlocFactory,
                  synthesizerBlocFactory,
                ) =>
                    MultiProvider(
                      providers: [
                        StatefulProvider<CardReviewBloc>(
                          valueBuilder: (_) => cardReviewBlocFactory.create(
                                session: authenticationBloc.session,
                              )..initialize(),
                        ),
                        StatefulProvider<SynthesizerBloc>(
                          valueBuilder: (_) => synthesizerBlocFactory.create(),
                        ),
                      ],
                      child: child,
                    ),
              ),
          settings: settings,
        );
}
