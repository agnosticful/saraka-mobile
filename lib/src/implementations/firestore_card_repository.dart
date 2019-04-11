import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';
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
  ValueObservable<Iterable<Card>> subscribeCards({@required User user}) {
    final observable = BehaviorSubject<Iterable<Card>>();

    final subscription = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .orderBy('nextStudyInterval', descending: true)
        .limit(1000)
        .snapshots()
        .listen((snapshot) {
      final cards =
          snapshot.documents.map((document) => FirestoreCard(document));

      observable.add(cards);
    });

    observable.onCancel = () => subscription.cancel();

    return observable;
  }

  @override
  ValueObservable<List<Card>> subscribeInQueueCards({@required User user}) {
    final observable = BehaviorSubject<List<Card>>();

    final subscription = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .where('nextStudyScheduledAt', isLessThanOrEqualTo: Timestamp.now())
        .orderBy('nextStudyScheduledAt')
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
    User user,
    Card card,
  }) {
    final observable = BehaviorSubject<List<Review>>();

    final subscription = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .document(card.id)
        .collection('studySnapshots')
        .orderBy('studiedAt', descending: true)
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
  Future<void> deleteCard({User user, Card card}) => Future.wait([
        Future.delayed(Duration(milliseconds: 600)),
        _firestore
            .collection('users')
            .document(user.id)
            .collection('cards')
            .document(card.id)
            .delete(),
      ]);
}
