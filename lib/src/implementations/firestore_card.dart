import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saraka/blocs.dart';

class FirestoreCard extends Card {
  FirestoreCard(DocumentSnapshot snapshot)
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
