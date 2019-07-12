import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/behaviors.dart';
import 'package:saraka/entities.dart';

abstract class AuthenticationBloc {
  ValueObservable<AuthenticationSession> get session;

  ValueObservable<bool> get isSigningIn;

  void restoreSession();

  void signIn();

  void signOut();
}

class _AuthenticationBloc implements AuthenticationBloc {
  _AuthenticationBloc({
    @required this.signable,
    @required this.signInOutLoggable,
  })  : assert(signable != null),
        assert(signInOutLoggable != null);

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
    @required Signable signable,
    @required SignInOutLoggable signInOutLoggable,
  })  : assert(signable != null),
        assert(signInOutLoggable != null),
        _signable = signable,
        _signInOutLoggable = signInOutLoggable;

  final Signable _signable;

  final SignInOutLoggable _signInOutLoggable;

  AuthenticationBloc create() => _AuthenticationBloc(
        signable: _signable,
        signInOutLoggable: _signInOutLoggable,
      );
}
