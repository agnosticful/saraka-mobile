import 'package:saraka/domains.dart';

abstract class Authentication {
  User get user;

  Stream<User> get onUserChange;

  void signIn();

  void signOut();
}
