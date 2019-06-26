import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/card_list_bloc.dart';

class DashboardRoute extends CupertinoPageRoute {
  DashboardRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) =>
              Consumer2<AuthenticationBloc, CardListBlocFactory>(
                builder:
                    (context, authenticationBloc, cardListBlocFactory, _) =>
                        Provider(
                          builder: (_) => cardListBlocFactory.create(
                                session: authenticationBloc.session,
                              ),
                          child: child,
                        ),
              ),
          settings: settings,
        );
}
