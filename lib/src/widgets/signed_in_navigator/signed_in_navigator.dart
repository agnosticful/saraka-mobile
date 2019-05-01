import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../blocs/authentication_bloc.dart';
import './card_list_route.dart';
import './dashboard_route.dart';
import './introduction_route.dart';
import './review_route.dart';
import './article_list_route.dart';

class SignedInNavigator extends StatefulWidget {
  SignedInNavigator({
    Key key,
    this.observers = const [],
    @required this.cardListBuilder,
    @required this.dashboardBuilder,
    @required this.introductionBuilder,
    @required this.reviewBuilder,
    @required this.articleListBuilder,
  })  : assert(cardListBuilder != null),
        assert(dashboardBuilder != null),
        assert(introductionBuilder != null),
        assert(reviewBuilder != null),
        assert(articleListBuilder != null),
        super(key: key);

  final List<NavigatorObserver> observers;

  final WidgetBuilder cardListBuilder;

  final WidgetBuilder introductionBuilder;

  final Widget Function(BuildContext, bool showTutorial) reviewBuilder;

  final WidgetBuilder dashboardBuilder;

  final WidgetBuilder articleListBuilder;

  @override
  State<SignedInNavigator> createState() => _SignedInNavigatorState();

  static String extractRouteName(RouteSettings routeSettings) => const {
        "/": "Dashboard",
        "/introduction": "Introduction",
        "/review": "Review",
        "/cards": "Card List",
        "/articles": "Article List",
      }[routeSettings.name];
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
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
        builder: (context, authenticationBloc) => StreamBuilder<User>(
              stream: authenticationBloc.user,
              initialData: authenticationBloc.user.value,
              builder: (context, snapshot) => Navigator(
                    key: _navigatorKey,
                    observers: widget.observers,
                    onGenerateRoute: (settings) {
                      switch (settings.name) {
                        case "/":
                          return DashboardRoute(
                            settings: settings,
                            child: widget.dashboardBuilder(context),
                          );
                        case "/introduction":
                          return IntroductionRoute(
                            settings: settings,
                            child: widget.introductionBuilder(context),
                          );
                        case "/review":
                          bool showTutorial = false;

                          if (settings.arguments != null) {
                            assert(settings.arguments is Map<String, bool>);

                            showTutorial = (settings.arguments
                                as Map<String, bool>)["showTutorial"];
                          }

                          return ReviewRoute(
                            settings: settings,
                            child: widget.reviewBuilder(context, showTutorial),
                          );
                        case "/cards":
                          return CardListRoute(
                            settings: settings,
                            child: widget.cardListBuilder(context),
                          );
                        case "/articles":
                          return ArticleListRoute(
                            settings: settings,
                            child: widget.cardListBuilder(context),
                          );
                      }
                    },
                    initialRoute: snapshot.hasData
                        ? snapshot.requireData.isIntroductionFinished
                            ? "/"
                            : "/introduction"
                        : "/",
                  ),
            ),
      );
}
