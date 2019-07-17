import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/card_list_bloc.dart';
import '../../bloc_factories/card_list_bloc_factory.dart';
import '../pages/dashboard_page.dart';
import '../pages/signed_out_page.dart';

class DashboardRoute extends CupertinoPageRoute {
  DashboardRoute({RouteSettings settings})
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
                        session: sessionSnapshot.requireData,
                      )..initialize(),
                      dispose: (_, cardListBloc) => cardListBloc.dispose(),
                      child: DashboardPage(),
                    )
                  : SignedOutPage(),
            ),
          ),
          settings: settings,
        );
}
