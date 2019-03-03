import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class FirebaseAuthenticationService implements AuthenticationService {
  FirebaseAuthenticationService({
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
  })  : assert(firebaseAuth != null),
        assert(googleSignIn != null),
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn;

  @override
  Stream<User> get onUserChange =>
      _firebaseAuth.onAuthStateChanged.map((firebaseUser) =>
          firebaseUser != null ? _FirebaseUser(firebaseUser) : null);

  @override
  Future<User> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuthentication = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken,
    );

    final firebaseUser = await _firebaseAuth.signInWithCredential(credential);

    return _FirebaseUser(firebaseUser);
  }

  @override
  Future<void> signOut() async => _firebaseAuth.signOut();
}

class _FirebaseUser extends User {
  _FirebaseUser(FirebaseUser firebaseUser)
      : assert(firebaseUser != null),
        id = firebaseUser.uid;

  final String id;
}
