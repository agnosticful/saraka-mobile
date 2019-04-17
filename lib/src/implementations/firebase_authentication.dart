import 'dart:async';
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
    Observable(_firebaseAuth.onAuthStateChanged).listen((firebaseUser) async {
      if (firebaseUser == null) {
        if (_lastUserFragmentSubscription != null) {
          _lastUserFragmentSubscription.cancel();

          _lastUserFragmentSubscription = null;
        }

        return _user.add(null);
      }

      _lastUserFragmentSubscription = _firestore
          .collection('users')
          .document(firebaseUser.uid)
          .snapshots()
          .listen((snapshot) {
        if (!snapshot.exists) {
          return _user.add(null);
        }

        final userFragment = _FirestoreUserFragment(snapshot);

        _user.add(_User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName,
          email: firebaseUser.email,
          imageUrl: Uri.parse(firebaseUser.photoUrl),
          isIntroductionFinished: userFragment.isIntroductionFinished,
        ));
      });
    });
  }

  final FirebaseAuth _firebaseAuth;

  final Firestore _firestore;

  final GoogleSignIn _googleSignIn;

  final _user = BehaviorSubject<User>();

  StreamSubscription _lastUserFragmentSubscription;

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
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}

class _User extends User {
  _User({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.imageUrl,
    @required this.isIntroductionFinished,
  })  : assert(id != null),
        assert(name != null),
        assert(email != null),
        assert(imageUrl != null),
        assert(isIntroductionFinished != null);

  final String id;

  final String name;

  final String email;

  final Uri imageUrl;

  final bool isIntroductionFinished;
}

class _FirestoreUserFragment {
  _FirestoreUserFragment(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        isIntroductionFinished = snapshot.data['isIntroductionFinished'];

  final bool isIntroductionFinished;
}
