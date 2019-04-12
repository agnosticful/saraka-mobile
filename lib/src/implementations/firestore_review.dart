import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saraka/blocs.dart';

class FirestoreReview extends Review {
  FirestoreReview(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        reviewedAt = (snapshot.data['studiedAt'] as Timestamp).toDate(),
        certainty = ReviewCertainty.parse(snapshot.data['certainty']),
        nextReviewInterval =
            Duration(milliseconds: snapshot.data['nextStudyInterval']);

  @override
  final DateTime reviewedAt;

  @override
  final ReviewCertainty certainty;

  @override
  final Duration nextReviewInterval;
}
