import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import 'package:flutter/foundation.dart';
import '../behaviors/backend_version_gettable.dart';

abstract class BackendVersionCompatibilityCheckBloc {
  ValueObservable<bool> get isCompatibleWithCurrentBackend;
}

class _BackendVersionCompatibilityCheckBloc
    implements BackendVersionCompatibilityCheckBloc {
  _BackendVersionCompatibilityCheckBloc({
    @required BackendVersionGettable backendVersionGettable,
  }) : assert(backendVersionGettable != null) {
    backendVersionGettable.getBackendVersion().then((version) {
      debugPrint('Expected backend version: $expectedBackendVersion');
      debugPrint('Backend version: $version');

      isCompatibleWithCurrentBackend.add(version <= expectedBackendVersion);
    });
  }

  @override
  final BehaviorSubject<bool> isCompatibleWithCurrentBackend =
      BehaviorSubject();
}

class BackendVersionCompatibilityCheckBlocFactory {
  BackendVersionCompatibilityCheckBlocFactory({
    @required BackendVersionGettable backendVersionGettable,
  })  : assert(backendVersionGettable != null),
        _backendVersionGettable = backendVersionGettable;

  final BackendVersionGettable _backendVersionGettable;

  BackendVersionCompatibilityCheckBloc create() =>
      _BackendVersionCompatibilityCheckBloc(
        backendVersionGettable: _backendVersionGettable,
      );
}
