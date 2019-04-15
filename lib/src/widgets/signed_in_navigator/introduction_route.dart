import 'package:flutter/material.dart';

class IntroductionRoute extends MaterialPageRoute {
  IntroductionRoute({@required Widget child, RouteSettings settings})
      : super(
          builder: (BuildContext context) => child,
          settings: settings,
        );
}
