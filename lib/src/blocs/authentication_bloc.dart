import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import './commons/authenticatable.dart';

class AuthenticationBlocFactory {
  AuthenticationBlocFactory({
    @required Authenticatable authenticatable,
    @required LoggerUserStateSettable loggerUserStateSettable,
    @required Signable signable,
    @required SignInOutLoggable signInOutLoggable,
  })  : assert(authenticatable != null),
        assert(loggerUserStateSettable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        _authenticatable = authenticatable,
        _loggerUserStateSettable = loggerUserStateSettable,
        _signable = signable,
        _signInOutLoggable = signInOutLoggable;

  final Authenticatable _authenticatable;

  final LoggerUserStateSettable _loggerUserStateSettable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  AuthenticationBloc create() => _AuthenticationBloc(
        authenticatable: _authenticatable,
        loggerUserStateSettable: _loggerUserStateSettable,
        signable: _signable,
        signInOutLoggable: _signInOutLoggable,
      );
}

abstract class AuthenticationBloc {
  ValueObservable<User> get user;

  ValueObservable<bool> get isSigningIn;

  void signIn();

  void signOut();
}

class _AuthenticationBloc implements AuthenticationBloc {
  _AuthenticationBloc({
    @required Authenticatable authenticatable,
    @required LoggerUserStateSettable loggerUserStateSettable,
    @required Signable signable,
    @required SignInOutLoggable signInOutLoggable,
  })  : assert(authenticatable != null),
        assert(loggerUserStateSettable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        _authenticatable = authenticatable,
        _signable = signable,
        _signInOutLoggable = signInOutLoggable {
    _authenticatable.user.listen((user) {
      loggerUserStateSettable.setUserState(user: user);
    });
  }

  final Authenticatable _authenticatable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  @override
  ValueObservable<User> get user => _authenticatable.user;

  @override
  final BehaviorSubject<bool> isSigningIn = BehaviorSubject.seeded(false);

  @override
  void signIn() async {
    isSigningIn.add(true);

    try {
      await _signable.signIn();
    } finally {
      isSigningIn.add(false);
    }

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

mixin LoggerUserStateSettable {
  Future<void> setUserState({@required User user});
}
