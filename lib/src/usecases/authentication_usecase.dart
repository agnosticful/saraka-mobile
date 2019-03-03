import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class AuthenticationUsecase {
  AuthenticationUsecase({
    @required AuthenticationService authenticationService,
  })  : assert(authenticationService != null),
        _authenticationService = authenticationService;

  final AuthenticationService _authenticationService;

  Authentication call() => _Authentication(_authenticationService);
}

class _Authentication extends Authentication {
  _Authentication(this._authenticationService)
      : assert(_authenticationService != null);

  final AuthenticationService _authenticationService;

  User _user;

  @override
  User get user => _user;

  @override
  Stream<User> get onUserChange => _authenticationService.onUserChange;

  @override
  Future<void> signIn() async {
    _user = await _authenticationService.signIn();
  }

  @override
  Future<void> signOut() async {
    await _authenticationService.signOut();

    _user = null;
  }
}
