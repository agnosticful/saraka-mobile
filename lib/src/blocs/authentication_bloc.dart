import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';

export '../entities/authentication_session.dart';

abstract class AuthenticationBloc {
  ValueObservable<AuthenticationSession> get session;

  ValueObservable<bool> get isSigningIn;

  void restoreSession();

  void signIn();

  void signOut();

  void initialize();

  void dispose();
}
