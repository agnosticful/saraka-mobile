import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../blocs/maintenance_check_bloc.dart';
import './maintenance_route.dart';
import './normal_route.dart';

class MaintenanceCheckNavigator extends StatefulWidget {
  MaintenanceCheckNavigator({
    Key key,
    this.observers = const [],
    @required this.builder,
  });

  final List<NavigatorObserver> observers;

  final WidgetBuilder builder;

  @override
  State<StatefulWidget> createState() => _MaintenanceCheckNavigatorState();

  static String extractRouteName(RouteSettings routeSettings) => const {
        "/maintenance": "Under Maintenance",
      }[routeSettings.name];
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
        observers: widget.observers,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return NormalRoute(
                settings: settings,
                child: widget.builder(context),
              );
            case "/maintenance":
              return MaintenanceRoute(settings: settings);
          }
        },
        initialRoute: "/",
      );
}
