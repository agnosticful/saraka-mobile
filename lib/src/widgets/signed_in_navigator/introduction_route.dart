import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../blocs/introduction_bloc.dart';

class IntroductionRoute extends CupertinoPageRoute {
  IntroductionRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => StatefulProvider(
                valueBuilder: (_) =>
                    Provider.of<IntroductionBlocFactory>(context).create(),
                child: child,
              ),
          settings: settings,
        );
}
