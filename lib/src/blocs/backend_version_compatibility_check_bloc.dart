import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import 'package:flutter/foundation.dart';

class BackendVersionCompatibilityCheckBlocFactory {
  BackendVersionCompatibilityCheckBlocFactory({
    @required BackendVersionGetable backendVersionGetable,
  })  : assert(backendVersionGetable != null),
        _backendVersionGetable = backendVersionGetable;

  final BackendVersionGetable _backendVersionGetable;

  BackendVersionCompatibilityCheckBloc create() =>
      _BackendVersionCompatibilityCheckBloc(
        backendVersionGetable: _backendVersionGetable,
      );
}

abstract class BackendVersionCompatibilityCheckBloc {
  ValueObservable<bool> get isCompatibleWithCurrentBackend;
}

class _BackendVersionCompatibilityCheckBloc
    implements BackendVersionCompatibilityCheckBloc {
  _BackendVersionCompatibilityCheckBloc({
    @required BackendVersionGetable backendVersionGetable,
  }) : assert(backendVersionGetable != null) {
    backendVersionGetable.getBackendVersion().then((version) {
      debugPrint('Expected backend version: $expectedBackendVersion');
      debugPrint('Backend version: $version');

      isCompatibleWithCurrentBackend.add(version <= expectedBackendVersion);
    });
  }

  @override
  final BehaviorSubject<bool> isCompatibleWithCurrentBackend =
      BehaviorSubject();
}

mixin BackendVersionGetable {
  Future<int> getBackendVersion();
}

class BackendVersionGetException implements Exception {
  BackendVersionGetException(this.data);

  final Map<dynamic, dynamic> data;

  String toString() => 'BackendVersionGetException: data is\n$data';
}
