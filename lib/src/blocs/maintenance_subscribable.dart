import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

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
