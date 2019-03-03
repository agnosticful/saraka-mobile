import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LandingRoute extends PageRoute {
  LandingRoute({RouteSettings settings}) : super(settings: settings);

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
      settings != null && settings.isInitialRoute
          ? child
          : FadeTransition(opacity: animation, child: child);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      FlareActor(
        "assets/flare/Mountain.flr",
        alignment: Alignment.center,
        fit: BoxFit.cover,
        animation: "rotate",
      );
}
