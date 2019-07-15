import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
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
                  ? Provider(
                      builder: (_) => cardListBlocFactory.create(
                        session: authenticationBloc.session.value,
                      ),
                      child: CardListPage(),
                    )
                  : SignedOutPage(),
            ),
          ),
          settings: settings,
        );
}
