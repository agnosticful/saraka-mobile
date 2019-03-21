import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';

class TrackedFirebaseAuthentication implements Authenticatable, Signable {
  TrackedFirebaseAuthentication({
    @required FirebaseAnalytics firebaseAnalytics,
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
  })  : assert(firebaseAnalytics != null),
        assert(firebaseAuth != null),
        assert(googleSignIn != null),
        _firebaseAnalytics = firebaseAnalytics,
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn {
    _firebaseAuth.onAuthStateChanged.listen((fUser) {
      _user.add(
        fUser == null
            ? null
            : _User(
                id: fUser.uid,
                name: fUser.displayName,
                email: fUser.email,
                imageUrl: Uri.parse(fUser.photoUrl),
              ),
      );
    });
  }

  final FirebaseAnalytics _firebaseAnalytics;

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

    _firebaseAnalytics.logLogin();
  }

  @override
  Future<void> signOut() async {
    _firebaseAuth.signOut();

    _firebaseAnalytics.logEvent(name: 'logout');
  }
}

class _User extends User {
  _User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null),
        assert(imageUrl != null);

  final String id;

  final String name;

  final String email;

  final Uri imageUrl;
}
