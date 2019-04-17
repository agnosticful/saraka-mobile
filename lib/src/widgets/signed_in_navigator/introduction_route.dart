import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

class IntroductionRoute extends MaterialPageRoute {
  IntroductionRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => StatefulProvider(
                valueBuilder: (_) =>
                    Provider.of<FirstCardListBlocFactory>(context).create(),
                child: child,
              ),
          settings: settings,
        );
}
