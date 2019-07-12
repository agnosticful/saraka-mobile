import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/src/view/routes/card_confirm_deletion_route.dart';
import 'package:saraka/src/view/routes/card_create_route.dart';
import '../routes/card_list_route.dart';
import '../routes/dashboard_route.dart';
import '../routes/review_route.dart';

class SarakaNavigator extends StatefulWidget {
  SarakaNavigator({
    Key key,
    this.observers = const [],
  }) : super(key: key);

  final List<NavigatorObserver> observers;

  @override
  State<SarakaNavigator> createState() => _SarakaNavigatorState();

  static String extractRouteName(RouteSettings routeSettings) => const {
        "/": "Dashboard",
        "/review": "Review",
        "/cards": "Card List",
      }[routeSettings.name];
}

class _SarakaNavigatorState extends State<SarakaNavigator>
    implements WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() async {
    assert(mounted);

    final NavigatorState navigator = _navigatorKey.currentState;

    return await navigator.maybePop();
  }

  @override
  Future<bool> didPushRoute(String route) async {
    assert(mounted);

    final NavigatorState navigator = _navigatorKey.currentState;

    navigator.pushNamed(route);

    return true;
  }

  @override
  void didChangeLocales(List<Locale> locales) {}

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {});
  }

  @override
  void didChangeMetrics() {
    setState(() {});
  }

  @override
  void didChangeTextScaleFactor() {
    setState(() {});
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
        builder: (context, authenticationBloc, _) => Navigator(
              key: _navigatorKey,
              observers: widget.observers,
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case "/":
                    return DashboardRoute(settings: settings);
                  case "/review":
                    return ReviewRoute(settings: settings);
                  case "/cards":
                    return CardListRoute(settings: settings);
                  case "/cards:new":
                    return CardCreateRoute(settings: settings);
                  case "/cards:confirmDeletion":
                    return CardConfirmDeletionRoute(settings: settings);
                }
              },
            ),
      );
}
