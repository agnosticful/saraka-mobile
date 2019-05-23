import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../behaviors/introduction_finishable.dart';
import '../behaviors/user_data_gettable.dart';
import '../entities/authentication_session.dart';

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

  @override
  Future<void> finishMidwayIntroduction(
      {AuthenticationSession session, String introName}) {
    return _firestore.collection('users').document(session.userId).updateData({
      "midwayIntroduction": {introName: DateTime.now()},
    });
  }
}

class _FirestoreUserData implements UserData {
  _FirestoreUserData(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        isIntroductionFinished = snapshot.data['isIntroductionFinished'];

  final bool isIntroductionFinished;
}
