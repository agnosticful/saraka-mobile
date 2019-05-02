import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../blocs/introduction_finishable.dart';
import '../blocs/user_data_gettable.dart';

class FirestoreUserRepository
    implements IntroductionFinishable, UserDataGettable {
  FirestoreUserRepository({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Future<UserData> getUserData({@required AuthenticationSession session}) =>
      _firestore
          .collection('users')
          .document(session.userId)
          .get()
          .then((snapshot) => _FirestoreUserData(snapshot));

  @override
  Future<void> finishIntroduction({AuthenticationSession session}) =>
      _firestore.collection('users').document(session.userId).updateData({
        "isIntroductionFinished": true,
      });
}

class _FirestoreUserData implements UserData {
  _FirestoreUserData(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        isIntroductionFinished = snapshot.data['isIntroductionFinished'];

  final bool isIntroductionFinished;
}
