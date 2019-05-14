import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../behaviors/card_deletable.dart';
import '../behaviors/card_subscribable.dart';
import '../behaviors/in_queue_card_subscribable.dart';
import '../behaviors/review_subscribable.dart';
import './firestore_card.dart';
import './firestore_review.dart';

class FirestoreCardRepository
    implements
        CardDeletable,
        CardSubscribable,
        InQueueCardSubscribable,
        ReviewSubscribable {
  FirestoreCardRepository({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  ValueObservable<List<Card>> subscribeCards({
    @required AuthenticationSession session,
  }) {
    final observable = BehaviorSubject<List<Card>>();

    final subscription = _firestore
        .collection('users')
        .document(session.userId)
        .collection('cards')
        .orderBy('nextReviewInterval', descending: true)
        .orderBy('text')
        .limit(1000)
        .snapshots()
        .listen((snapshot) {
      final cards = snapshot.documents
          .map((document) => FirestoreCard(document))
          .toList();

      observable.add(cards);
    });

    observable.onCancel = () => subscription.cancel();

    return observable;
  }

  @override
  ValueObservable<List<Card>> subscribeInQueueCards({
    @required AuthenticationSession session,
  }) {
    final observable = BehaviorSubject<List<Card>>();

    final subscription = _firestore
        .collection('users')
        .document(session.userId)
        .collection('cards')
        .where('nextReviewScheduledFor', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('nextReviewScheduledFor')
        .limit(1000)
        .snapshots()
        .listen((snapshot) {
      observable.add(snapshot.documents
          .map((document) => FirestoreCard(document))
          .toList());
    });

    observable.onCancel = () => subscription.cancel();

    return observable;
  }

  @override
  Observable<List<Review>> subscribeReviewsInCard({
    AuthenticationSession session,
    Card card,
  }) {
    final observable = BehaviorSubject<List<Review>>();

    final subscription = _firestore
        .collection('users')
        .document(session.userId)
        .collection('cards')
        .document(card.id)
        .collection('reviews')
        .orderBy('reviewedAt', descending: true)
        .limit(1000)
        .snapshots()
        .listen((snapshot) {
      observable.add(snapshot.documents
          .map((document) => FirestoreReview(document))
          .toList());
    });

    observable.onCancel = () => subscription.cancel();

    return observable;
  }

  @override
  Future<void> deleteCard({
    Card card,
    AuthenticationSession session,
  }) =>
      Future.wait([
        Future.delayed(Duration(milliseconds: 600)),
        _firestore
            .collection('users')
            .document(session.userId)
            .collection('cards')
            .document(card.id)
            .delete(),
      ]);
}
