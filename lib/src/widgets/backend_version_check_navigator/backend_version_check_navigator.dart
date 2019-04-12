import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './incompatible_route.dart';
import './normal_route.dart';

class BackendVersionCheckNavigator extends StatefulWidget {
  BackendVersionCheckNavigator({Key key, @required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => _BackendVersionCheckNavigatorState();
}

class _BackendVersionCheckNavigatorState
    extends State<BackendVersionCheckNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription _subscription;

  bool _previousIsCompatible = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final backendVersionCompatibilityCheckBloc =
          Provider.of<BackendVersionCompatibilityCheckBloc>(context);

      _subscription = backendVersionCompatibilityCheckBloc
          .isCompatibleWithCurrentBackend
          .listen((isCompatible) {
        if (isCompatible == _previousIsCompatible) {
          return;
        }

        if (isCompatible) {
          _navigatorKey.currentState.pushNamedAndRemoveUntil('/', (_) => false);
        } else {
          _navigatorKey.currentState
              .pushNamedAndRemoveUntil('/incompatible', (_) => false);
        }

        _previousIsCompatible = isCompatible;
      });
    });
  }

  @override
  void dispose() {
    _subscription ?? _subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return NormalRoute(settings: settings, child: widget.child);
            case "/incompatible":
              return IncompatibleRoute(settings: settings);
          }
        },
        initialRoute: "/",
      );
}
