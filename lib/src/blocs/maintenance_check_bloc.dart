import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class MaintenanceCheckBlocFactory {
  MaintenanceCheckBlocFactory({
    @required MaintenanceSubscribable maintenanceSubscribable,
  })  : assert(maintenanceSubscribable != null),
        _maintenanceSubscribable = maintenanceSubscribable;

  final MaintenanceSubscribable _maintenanceSubscribable;

  MaintenanceCheckBloc create() => _MaintenanceCheckBloc(
        maintenanceSubscribable: _maintenanceSubscribable,
      );
}

abstract class MaintenanceCheckBloc {
  ValueObservable<Maintenance> get maintenance;
}

class _MaintenanceCheckBloc implements MaintenanceCheckBloc {
  _MaintenanceCheckBloc({
    @required MaintenanceSubscribable maintenanceSubscribable,
  })  : assert(maintenanceSubscribable != null),
        _maintenanceSubscribable = maintenanceSubscribable;

  final MaintenanceSubscribable _maintenanceSubscribable;

  @override
  ValueObservable<Maintenance> get maintenance =>
      _maintenanceSubscribable.subscribeMaintenance();
}

mixin MaintenanceSubscribable {
  /// Returns a value observable of [Maintenance]. If the backend is not in maintenance, event value is `null`.
  ValueObservable<Maintenance> subscribeMaintenance();
}

class Maintenance {
  Maintenance({@required this.startedAt, @required this.finishedAt})
      : assert(startedAt != null),
        assert(finishedAt != null);

  final DateTime startedAt;

  final DateTime finishedAt;
}
