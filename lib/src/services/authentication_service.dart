import 'package:saraka/domains.dart';

abstract class AuthenticationService {
  Stream<User> get onUserChange;

  Future<User> signIn();

  Future<void> signOut();
}
