import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/card_review_bloc.dart';
import '../../bloc_factories/card_review_bloc_factory.dart';
import '../pages/review_page.dart';
import '../pages/signed_out_page.dart';

class ReviewRoute extends MaterialPageRoute {
  ReviewRoute({RouteSettings settings})
      : super(
          builder: (BuildContext context) =>
              Consumer2<AuthenticationBloc, CardReviewBlocFactory>(
            builder: (
              context,
              authenticationBloc,
              cardReviewBlocFactory,
              _,
            ) =>
                StreamBuilder(
              stream: authenticationBloc.session,
              initialData: authenticationBloc.session.value,
              builder: (context, sessionSnapshot) => sessionSnapshot.hasData
                  ? Provider<CardReviewBloc>(
                      builder: (_) => cardReviewBlocFactory.create(
                        session: authenticationBloc.session.value,
                      )..initialize(),
                      dispose: (_, cardReviewBloc) => cardReviewBloc.dispose(),
                      child: ReviewPage(),
                    )
                  : SignedOutPage(),
            ),
          ),
          settings: settings,
        );
}
