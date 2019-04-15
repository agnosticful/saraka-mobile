import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';

class FirebaseAuthentication implements Authenticatable, Signable {
  FirebaseAuthentication({
    @required FirebaseAuth firebaseAuth,
    @required GoogleSignIn googleSignIn,
    @required Firestore firestore,
  })  : assert(firebaseAuth != null),
        assert(googleSignIn != null),
        assert(firestore != null),
        _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn {
    _firebaseAuth.onAuthStateChanged.listen((fUser) async {
      if (fUser == null) {
        return _user.add(null);
      }

      final isNew = await _firestore
          .collection('users')
          .document(fUser.uid)
          .collection('cards')
          .limit(1)
          .getDocuments()
          .then((snapshot) => snapshot.documents.length == 0);

      _user.add(_User(
        id: fUser.uid,
        name: fUser.displayName,
        email: fUser.email,
        imageUrl: Uri.parse(fUser.photoUrl),
        isNew: isNew,
      ));
    });
  }

  final FirebaseAuth _firebaseAuth;

  final Firestore _firestore;

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
  Future<void> signOut() => _firebaseAuth.signOut();
}

class _User extends User {
  _User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
    @required this.isNew,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null),
        assert(imageUrl != null),
        assert(isNew != null);

  final String id;

  final String name;

  final String email;

  final Uri imageUrl;

  final bool isNew;
}
