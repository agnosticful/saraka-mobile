import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class CloudFirestoreService implements RepositoryService {
  CloudFirestoreService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Stream<List<Card>> subscribeCards({@required User user}) => _firestore
      .collection('users')
      .document(user.id)
      .collection('cards')
      .orderBy('lastStudiedAt', descending: true)
      .orderBy('createdAt', descending: true)
      .limit(1000)
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map((document) => _FirestoreCard(document))
          .toList());

  @override
  Future<void> addNewCard({@required User user, @required String text}) async {
    final document = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .document(idify(text));

    if ((await document.get()).exists) {
      throw new CardDuplicationException(text);
    }

    await document.setData({
      "text": text,
      "createdAt": FieldValue.serverTimestamp(),
      "lastStudiedAt": null,
    });
  }
}

String idify(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'[^0-9A-Za-z]'), '-');

class _FirestoreCard extends Card {
  _FirestoreCard(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        text = snapshot.data['text'];

  @override
  final String id;

  @override
  final String text;
}
