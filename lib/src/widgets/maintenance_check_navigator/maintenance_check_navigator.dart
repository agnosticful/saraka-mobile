import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import './maintenance_route.dart';
import './normal_route.dart';

class MaintenanceCheckNavigator extends StatefulWidget {
  MaintenanceCheckNavigator({Key key, @required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => _MaintenanceCheckNavigatorState();
}

class _MaintenanceCheckNavigatorState extends State<MaintenanceCheckNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription _subscription;

  bool isInitialized = false;

  Maintenance _previousMaintenance;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final maintenanceCheckBloc = Provider.of<MaintenanceCheckBloc>(context);

      _subscription =
          maintenanceCheckBloc.maintenance.listen((maintenanceState) {
        if (maintenanceState == _previousMaintenance) {
          return;
        }

        if (maintenanceState == null) {
          _navigatorKey.currentState.pushNamedAndRemoveUntil('/', (_) => false);
        } else {
          _navigatorKey.currentState
              .pushNamedAndRemoveUntil('/maintenance', (_) => false);
        }

        _previousMaintenance = maintenanceState;
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
            case "/maintenance":
              return MaintenanceRoute(settings: settings);
          }
        },
        initialRoute: "/",
      );
}
