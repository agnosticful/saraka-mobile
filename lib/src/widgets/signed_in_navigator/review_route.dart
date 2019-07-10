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
                  _,
                ) =>
                    MultiProvider(
                      providers: [
                        Provider<CardReviewBloc>(
                          builder: (_) => cardReviewBlocFactory.create(
                                session: authenticationBloc.session.value,
                              )..initialize(),
                        ),
                        Provider<SynthesizerBloc>(
                          builder: (_) => synthesizerBlocFactory.create(),
                        ),
                      ],
                      child: child,
                    ),
              ),
          settings: settings,
        );
}
