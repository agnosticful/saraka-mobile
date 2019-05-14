import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../behaviors/maintenance_subscribable.dart';
export '../behaviors/maintenance_subscribable.dart' show Maintenance;

abstract class MaintenanceCheckBloc {
  ValueObservable<Maintenance> get maintenance;
}

class _MaintenanceCheckBloc implements MaintenanceCheckBloc {
  _MaintenanceCheckBloc({
    @required this.maintenanceSubscribable,
  }) : assert(maintenanceSubscribable != null);

  final MaintenanceSubscribable maintenanceSubscribable;

  @override
  ValueObservable<Maintenance> get maintenance =>
      maintenanceSubscribable.subscribeMaintenance();
}

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
