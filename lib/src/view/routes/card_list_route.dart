import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/card_list_bloc.dart';
import '../../bloc_factories/card_list_bloc_factory.dart';
import '../pages/card_list_page.dart';
import '../pages/signed_out_page.dart';

class CardListRoute extends MaterialPageRoute {
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
              builder: (context, sessionSnapshot) => sessionSnapshot.hasData
                  ? Provider<CardListBloc>(
                      builder: (_) => cardListBlocFactory.create(
                        session: authenticationBloc.session.value,
                      )..initialize(),
                      dispose: (_, cardListBloc) => cardListBloc.dispose(),
                      child: CardListPage(),
                    )
                  : SignedOutPage(),
            ),
          ),
          settings: settings,
        );
}
