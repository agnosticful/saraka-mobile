import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import './commons/authenticatable.dart';

class AuthenticationBlocFactory {
  AuthenticationBlocFactory({
    @required Authenticatable authenticatable,
    @required Signable signable,
  })  : assert(authenticatable != null),
        assert(signable != null),
        _authenticatable = authenticatable,
        _signable = signable;

  final Authenticatable _authenticatable;

  final Signable _signable;

  AuthenticationBloc create() => _AuthenticationBloc(
        authenticatable: _authenticatable,
        signable: _signable,
      );
}

abstract class AuthenticationBloc {
  ValueObservable<User> get user;

  void signIn();

  void signOut();
}

class _AuthenticationBloc implements AuthenticationBloc {
  _AuthenticationBloc({
    @required Authenticatable authenticatable,
    @required Signable signable,
  })  : assert(authenticatable != null),
        assert(signable != null),
        _authenticatable = authenticatable,
        _signable = signable;

  final Authenticatable _authenticatable;

  final Signable _signable;

  @override
  ValueObservable<User> get user => _authenticatable.user;

  @override
  void signIn() => _signable.signIn();

  @override
  void signOut() => _signable.signOut();
}

mixin Signable {
  Future<void> signIn();

  Future<void> signOut();
}
