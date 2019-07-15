import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
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
                  ? Provider(
                      builder: (_) => cardListBlocFactory.create(
                        session: sessionSnapshot.requireData,
                      ),
                      child: DashboardPage(),
                    )
                  : SignedOutPage(),
            ),
          ),
          settings: settings,
        );
}
