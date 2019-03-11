import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';

class FirebaseAuthentication implements Authenticatable, Signable {
  FirebaseAuthentication({
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
  })  : assert(firebaseAuth != null),
        assert(googleSignIn != null),
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn {
    _firebaseAuth.onAuthStateChanged.listen((fUser) {
      _user.add(fUser == null ? null : _User(id: fUser.uid));
    });
  }

  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn;

  final _user = BehaviorSubject<User>();

  @override
  ValueObservable<User> get user => _user;

  @override
  Future<void> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuthentication = await googleUser.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async => _firebaseAuth.signOut();
}

class _User extends User {
  _User({@required this.id}) : assert(id != null);

  final String id;
}
