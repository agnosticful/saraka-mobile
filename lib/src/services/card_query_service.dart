import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc_factories/card_list_bloc_factory.dart';
import '../bloc_factories/card_review_bloc_factory.dart';

class CardQueryService implements CardListable, InQueueCardListable {
  CardQueryService({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Observable<List<Card>> subscribeCards({
    @required AuthenticationSession session,
  }) =>
      Observable(_getCardsCollection(session)
          .orderBy('nextReviewInterval', descending: true)
          .orderBy('text')
          .limit(1000)
          .snapshots()
          .map((snapshot) => snapshot.documents
              .map((document) => _FirestoreCard(document))
              .toList()));

  Observable<List<Card>> subscribeInQueueCards({
    @required AuthenticationSession session,
  }) =>
      Observable(_getCardsCollection(session)
          .where('nextReviewScheduledFor', isLessThanOrEqualTo: Timestamp.now())
          .orderBy('nextReviewScheduledFor')
          .limit(1000)
          .snapshots()
          .map((snapshot) => snapshot.documents
              .map((document) => _FirestoreCard(document))
              .toList()));

  CollectionReference _getCardsCollection(AuthenticationSession session) =>
      _firestore
          .collection('users')
          .document(session.userId)
          .collection('cards');
}

class _FirestoreCard extends Card {
  _FirestoreCard(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        text = snapshot.data['text'],
        lastReviewedAt = snapshot.data['lastReviewedAt'] == null
            ? null
            : (snapshot.data['lastReviewedAt'] as Timestamp).toDate(),
        nextReviewScheduledAt =
            (snapshot.data['nextReviewScheduledFor'] as Timestamp).toDate(),
        nextReviewInterval =
            Duration(milliseconds: snapshot.data['nextReviewInterval']),
        modifier = snapshot.data['modifier'];

  @override
  final String id;

  @override
  final String text;

  @override
  final DateTime lastReviewedAt;

  @override
  final DateTime nextReviewScheduledAt;

  @override
  final Duration nextReviewInterval;

  @override
  final double modifier;
}
