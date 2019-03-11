import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/routes.dart';

class Application extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription _subscription;

  bool isInitialized = false;

  User _user;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final authenticationBloc = Provider.of<AuthenticationBloc>(context);

      _user = authenticationBloc.user.value;

      _subscription = authenticationBloc.user.listen((user) {
        if (_user == null && user != null) {
          _navigatorKey.currentState
              .pushNamedAndRemoveUntil('/signed_in', (_) => false);
        }

        if ((isInitialized == false || _user != null) && user == null) {
          _navigatorKey.currentState
              .pushNamedAndRemoveUntil('/signed_out', (_) => false);
        }

        isInitialized = true;

        _user = user;
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();

    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => WidgetsApp(
        title: 'Saraka',
        color: SarakaColors.darkCyan,
        localizationsDelegates: [
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        navigatorKey: _navigatorKey,
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
