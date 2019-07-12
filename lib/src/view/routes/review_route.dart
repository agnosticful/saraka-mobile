import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import '../pages/review_screen.dart';
import '../pages/signed_out_screen.dart';

class ReviewRoute extends MaterialPageRoute {
  ReviewRoute({RouteSettings settings})
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
                    StreamBuilder(
                      stream: authenticationBloc.session,
                      initialData: authenticationBloc.session.value,
                      builder: (context, sessionSnapshot) => sessionSnapshot
                              .hasData
                          ? MultiProvider(
                              providers: [
                                Provider<CardReviewBloc>(
                                  builder: (_) => cardReviewBlocFactory.create(
                                        session:
                                            authenticationBloc.session.value,
                                      )..initialize(),
                                ),
                                Provider<SynthesizerBloc>(
                                  builder: (_) =>
                                      synthesizerBlocFactory.create(),
                                ),
                              ],
                              child: ReviewScreen(),
                            )
                          : SignedOutScreen(),
                    ),
              ),
          settings: settings,
        );
}
