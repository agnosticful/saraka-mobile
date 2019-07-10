import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import '../../blocs/introduction_bloc.dart';

class IntroductionRoute extends CupertinoPageRoute {
  IntroductionRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) =>
              Consumer2<AuthenticationBloc, IntroductionBlocFactory>(
                builder:
                    (context, authenticationBloc, introductionBlocFactory, _) =>
                        Provider(
                          builder: (_) => introductionBlocFactory.create(
                                session: authenticationBloc.session.value,
                              ),
                          child: child,
                        ),
              ),
          settings: settings,
        );
}
