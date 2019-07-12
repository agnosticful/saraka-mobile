import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import '../pages/card_list_screen.dart';
import '../pages/signed_out_screen.dart';

class CardListRoute extends CupertinoPageRoute {
  CardListRoute({RouteSettings settings})
      : super(
          builder: (BuildContext context) =>
              Consumer2<AuthenticationBloc, CardListBlocFactory>(
                builder: (
                  context,
                  authenticationBloc,
                  cardListBlocFactory,
                  _,
                ) =>
                    StreamBuilder(
                      stream: authenticationBloc.session,
                      initialData: authenticationBloc.session.value,
                      builder: (context, sessionSnapshot) => sessionSnapshot
                              .hasData
                          ? Provider(
                              builder: (_) => cardListBlocFactory.create(
                                    session: authenticationBloc.session.value,
                                  ),
                              child: CardListScreen(),
                            )
                          : SignedOutScreen(),
                    ),
              ),
          settings: settings,
        );
}
