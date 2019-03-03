import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/routes.dart';

class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => WidgetsApp(
        builder: (context, _) => _AuthenticationManager(
              navigatorKey: _navigatorKey,
              authentication: Provider.of<Authentication>(context),
            ),
        color: SarakaColors.darkCyan,
      );
}

class _AuthenticationManager extends StatefulWidget {
  _AuthenticationManager({
    Key key,
    @required this.navigatorKey,
    @required this.authentication,
  })  : assert(navigatorKey != null),
        assert(authentication != null),
        super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  final Authentication authentication;

  State<_AuthenticationManager> createState() => _AuthenticationManagerState();
}

class _AuthenticationManagerState extends State<_AuthenticationManager> {
  StreamSubscription _subscription;

  bool isInitialized = false;

  User _user;

  @override
  void initState() {
    super.initState();

    _user = widget.authentication.user;

    _subscription = widget.authentication.onUserChange.listen((user) {
      if (_user == null && user != null) {
        print('sign in');

        widget.navigatorKey.currentState
            .pushNamedAndRemoveUntil('/signed_in', (_) => false);
      }

      if ((isInitialized == false || _user != null) && user == null) {
        print('sign out');

        widget.navigatorKey.currentState
            .pushNamedAndRemoveUntil('/signed_out', (_) => false);
      }

      isInitialized = true;
      _user = user;
    });
  }

  @override
  void deactivate() {
    super.deactivate();

    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: widget.navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return LandingRoute(settings: settings);
            case "/signed_in":
              return SignedInRoute(settings: settings);
            case "/signed_out":
              return SignedOutRoute(settings: settings);
          }
        },
        initialRoute: "/",
      );
}
