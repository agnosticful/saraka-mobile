import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

class DashboardRoute extends CupertinoPageRoute {
  DashboardRoute(
      {@required Widget normal,
      @required Widget introduction,
      RouteSettings settings})
      : super(
          builder: (BuildContext context) => Consumer<AuthenticationBloc>(
                builder: (context, authenticationBloc) => StreamBuilder<User>(
                      stream: authenticationBloc.user,
                      initialData: authenticationBloc.user.value,
                      builder: (context, snapshot) => snapshot.hasData
                          ? snapshot.requireData.isIntroductionFinished
                              ? StatefulProvider(
                                  valueBuilder: (_) =>
                                      Provider.of<CardListBlocFactory>(context)
                                          .create(),
                                  child: normal,
                                )
                              : StatefulProvider(
                                  valueBuilder: (_) =>
                                      Provider.of<IntroductionBlocFactory>(
                                              context)
                                          .create(),
                                  child: introduction,
                                )
                          : Container(),
                    ),
              ),
          settings: settings,
        );
}
