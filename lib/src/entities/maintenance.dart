import 'package:meta/meta.dart';

class Maintenance {
  Maintenance({@required this.startedAt, @required this.finishedAt})
      : assert(startedAt != null),
        assert(finishedAt != null);

  final DateTime startedAt;

  final DateTime finishedAt;
}
