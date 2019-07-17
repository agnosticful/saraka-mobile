import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc_factories/card_detail_bloc_factory.dart';

class ReviewQueryService implements CardReviewListable {
  ReviewQueryService({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Observable<List<Review>> subscribeReviewsOfCard({
    @required AuthenticationSession session,
    @required Card card,
  }) =>
      Observable(
        _firestore
            .collection('users')
            .document(session.userId)
            .collection('cards')
            .document(card.id)
            .collection('reviews')
            .orderBy('reviewedAt', descending: true)
            .limit(1000)
            .snapshots()
            .map((snapshot) => snapshot.documents
                .map((document) => _FirestoreReview(document))
                .toList()),
      );
}

class _FirestoreReview extends Review {
  _FirestoreReview(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        reviewedAt = (snapshot.data['reviewedAt'] as Timestamp).toDate(),
        certainty = ReviewCertainty.parse(snapshot.data['certainty']),
        nextReviewInterval =
            Duration(milliseconds: snapshot.data['nextReviewInterval']);

  @override
  final DateTime reviewedAt;

  @override
  final ReviewCertainty certainty;

  @override
  final Duration nextReviewInterval;
}
