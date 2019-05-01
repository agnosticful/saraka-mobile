import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
export '../entities/authentication_session.dart';

mixin Signable {
  Future<AuthenticationSession> restoreSession();

  Future<AuthenticationSession> signIn();

  Future<void> signOut({@required AuthenticationSession session});
}
