import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saraka/blocs.dart';

class FirestoreCard extends Card {
  FirestoreCard(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        text = snapshot.data['text'],
        lastReviewedAt = snapshot.data['lastStudiedAt'] == null
            ? null
            : (snapshot.data['lastStudiedAt'] as Timestamp).toDate(),
        nextReviewScheduledAt =
            (snapshot.data['nextStudyScheduledAt'] as Timestamp).toDate(),
        nextReviewInterval =
            Duration(milliseconds: snapshot.data['nextStudyInterval']);

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
}
