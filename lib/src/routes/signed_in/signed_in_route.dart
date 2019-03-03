import 'package:flutter/material.dart';
import './home_route/home_route.dart';

class SignedInRoute extends PageRoute {
  SignedInRoute({RouteSettings settings}) : super(settings: settings);

  @override
  final bool maintainState = true;

  @override
  final Duration transitionDuration = const Duration(milliseconds: 300);

  @override
  final Color barrierColor = null;

  @override
  final String barrierLabel = null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      FadeTransition(opacity: animation, child: child);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Material(
        child: Navigator(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return HomeRoute();
            }
          },
        ),
      );
}
