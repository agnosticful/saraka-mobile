import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import '../behaviors/signable.dart';

class FirebaseAuthentication implements Signable {
  FirebaseAuthentication({
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
  })  : assert(firebaseAuth != null),
        assert(googleSignIn != null),
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn;

  @override
  Future<AuthenticationSession> restoreSession() async {
    final firebaseUser = await _firebaseAuth.currentUser();

    return firebaseUser == null
        ? null
        : _FirebaseAuthenticationSession(firebaseUser);
  }

  @override
  Future<AuthenticationSession> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuthentication = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken,
    );

    final firebaseUser = await _firebaseAuth.signInWithCredential(credential);

    return _FirebaseAuthenticationSession(firebaseUser);
  }

  @override
  Future<void> signOut({AuthenticationSession session}) async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}

class _FirebaseAuthenticationSession implements AuthenticationSession {
  _FirebaseAuthenticationSession(FirebaseUser firebaseUser)
      : assert(firebaseUser != null),
        userId = firebaseUser.uid,
        name = firebaseUser.displayName,
        email = firebaseUser.email,
        imageUrl = Uri.parse(firebaseUser.photoUrl);

  final String userId;

  final String name;

  final String email;

  final Uri imageUrl;
}
