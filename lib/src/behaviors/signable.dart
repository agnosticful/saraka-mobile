import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

abstract class Signable {
  Future<AuthenticationSession> restoreSession();

  Future<AuthenticationSession> signIn();

  Future<void> signOut({@required AuthenticationSession session});
}
