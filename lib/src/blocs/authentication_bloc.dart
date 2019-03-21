import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import './commons/authenticatable.dart';

class AuthenticationBlocFactory {
  AuthenticationBlocFactory({
    @required Authenticatable authenticatable,
    @required Signable signable,
    @required SignInOutLoggable signInOutLoggable,
  })  : assert(authenticatable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        _authenticatable = authenticatable,
        _signable = signable,
        _signInOutLoggable = signInOutLoggable;

  final Authenticatable _authenticatable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  AuthenticationBloc create() => _AuthenticationBloc(
        authenticatable: _authenticatable,
        signable: _signable,
        signInOutLoggable: _signInOutLoggable,
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
    @required SignInOutLoggable signInOutLoggable,
  })  : assert(authenticatable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        _authenticatable = authenticatable,
        _signable = signable,
        _signInOutLoggable = signInOutLoggable;

  final Authenticatable _authenticatable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  @override
  ValueObservable<User> get user => _authenticatable.user;

  @override
  void signIn() async {
    await _signable.signIn();

    await _signInOutLoggable.logSignIn();
  }

  @override
  void signOut() async {
    _signable.signOut();

    await _signInOutLoggable.logSignOut();
  }
}

mixin Signable {
  Future<void> signIn();

  Future<void> signOut();
}

mixin SignInOutLoggable {
  Future<void> logSignIn();

  Future<void> logSignOut();
}
