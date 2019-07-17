import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/authentication_bloc.dart';

export '../entities/authentication_session.dart';

class AuthenticationBlocFactory {
  AuthenticationBlocFactory({
    @required Signable signable,
  })  : assert(signable != null),
        _signable = signable;

  final Signable _signable;

  AuthenticationBloc create() => _AuthenticationBloc(
        signable: _signable,
      );
}

abstract class Signable {
  Future<AuthenticationSession> restoreSession();

  Future<AuthenticationSession> signIn();

  Future<void> signOut({@required AuthenticationSession session});
}

abstract class SignInOutLoggable {
  Future<void> logSignIn();

  Future<void> logSignOut();
}

class _AuthenticationBloc implements AuthenticationBloc {
  _AuthenticationBloc({@required this.signable}) : assert(signable != null);

  final Signable signable;

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
    }

    isSigningIn.add(false);
  }

  @override
  void signIn() async {
    isSigningIn.add(true);

    try {
      session.add(await signable.signIn());
    } finally {
      isSigningIn.add(false);
    }
  }

  @override
  void signOut() async {
    assert(session.value != null);

    signable.signOut(session: session.value);

    session.add(null);
  }

  @override
  void initialize() {}

  @override
  void dispose() {}
}
