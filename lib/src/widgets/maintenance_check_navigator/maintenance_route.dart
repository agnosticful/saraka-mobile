import 'package:flutter/widgets.dart';
import '../maintenance_screen.dart';

class MaintenanceRoute extends PageRoute {
  MaintenanceRoute({RouteSettings settings}) : super(settings: settings);

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
      MaintenanceScreen();
}
