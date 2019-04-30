import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/review.dart';
import '../entities/review_certainty.dart';

class FirestoreReview extends Review {
  FirestoreReview(DocumentSnapshot snapshot)
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
