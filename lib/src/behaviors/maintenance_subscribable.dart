import 'package:rxdart/rxdart.dart';
import '../entities/maintenance.dart';

abstract class MaintenanceSubscribable {
  /// Returns a value observable of [Maintenance]. If the backend is not in maintenance, event value is `null`.
  ValueObservable<Maintenance> subscribeMaintenance();
}
