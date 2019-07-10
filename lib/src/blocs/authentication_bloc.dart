import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../behaviors/logger_user_state_settable.dart';
import '../behaviors/sign_in_out_loggable.dart';
import '../behaviors/signable.dart';
import '../entities/authentication_session.dart';

abstract class AuthenticationBloc {
  ValueObservable<AuthenticationSession> get session;

  ValueObservable<bool> get isSigningIn;

  void restoreSession();

  void signIn();

  void signOut();
}

class _AuthenticationBloc implements AuthenticationBloc {
  _AuthenticationBloc({
    @required this.loggerUserStateSettable,
    @required this.signable,
    @required this.signInOutLoggable,
  })  : assert(loggerUserStateSettable != null),
        assert(signable != null),
        assert(signInOutLoggable != null);

  final LoggerUserStateSettable loggerUserStateSettable;

  final Signable signable;

  final SignInOutLoggable signInOutLoggable;

  @override
  final BehaviorSubject<AuthenticationSession> session =
      BehaviorSubject.seeded(null);

  @override
  final BehaviorSubject<bool> isSigningIn = BehaviorSubject.seeded(false);

  @override
  void restoreSession() async {
    isSigningIn.add(true);

    final _session = await signable.restoreSession();

    if (_session != null) {
      session.add(_session);

      signInOutLoggable.logSignIn();
    }

    isSigningIn.add(false);
  }

  @override
  void signIn() async {
    isSigningIn.add(true);

    try {
      session.add(await signable.signIn());

      signInOutLoggable.logSignIn();
    } finally {
      isSigningIn.add(false);
    }
  }

  @override
  void signOut() async {
    assert(session.value != null);

    signable.signOut(session: session.value);

    signInOutLoggable.logSignOut();

    session.add(null);
  }
}

class AuthenticationBlocFactory {
  AuthenticationBlocFactory({
    @required LoggerUserStateSettable loggerUserStateSettable,
    @required Signable signable,
    @required SignInOutLoggable signInOutLoggable,
  })  : assert(loggerUserStateSettable != null),
        assert(signable != null),
        assert(signInOutLoggable != null),
        _loggerUserStateSettable = loggerUserStateSettable,
        _signable = signable,
        _signInOutLoggable = signInOutLoggable;

  final LoggerUserStateSettable _loggerUserStateSettable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  AuthenticationBloc create() => _AuthenticationBloc(
        loggerUserStateSettable: _loggerUserStateSettable,
        signable: _signable,
        signInOutLoggable: _signInOutLoggable,
      );
}
