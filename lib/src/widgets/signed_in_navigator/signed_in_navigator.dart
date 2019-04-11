import 'dart:async';
import 'package:flutter/widgets.dart';
import './card_list_route.dart';
import './study_route.dart';
import './dashboard_route.dart';

class SignedInNavigator extends StatefulWidget {
  SignedInNavigator({
    Key key,
    @required this.cardList,
    @required this.study,
    @required this.dashboard,
  })  : assert(cardList != null),
        assert(study != null),
        assert(dashboard != null),
        super(key: key);

  final Widget cardList;

  final Widget study;

  final Widget dashboard;

  @override
  State<SignedInNavigator> createState() => _SignedInNavigatorState();
}

class _SignedInNavigatorState extends State<SignedInNavigator>
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
  Widget build(BuildContext context) => Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return DashboardRoute(
                settings: settings,
                child: widget.dashboard,
              );
            case "/study":
              return StudyRoute(
                settings: settings,
                child: widget.study,
              );
            case "/cards":
              return CardListRoute(
                settings: settings,
                child: widget.cardList,
              );
          }
        },
        initialRoute: "/",
      );
}
