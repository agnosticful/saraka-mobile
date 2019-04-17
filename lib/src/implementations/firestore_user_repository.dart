import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:saraka/blocs.dart';

class FirestoreUserRepository implements IntroductionFinishable {
  FirestoreUserRepository({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  Future<void> finishIntroduction({User user}) =>
      _firestore.collection('users').document(user.id).updateData({
        "isIntroductionFinished": true,
      });
}
