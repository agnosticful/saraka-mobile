import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saraka/blocs.dart';

class FirestoreCard extends Card {
  FirestoreCard(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        text = snapshot.data['text'],
        lastStudiedAt = snapshot.data['lastStudiedAt'] == null
            ? null
            : (snapshot.data['lastStudiedAt'] as Timestamp).toDate(),
        nextStudyScheduledAt =
            (snapshot.data['nextStudyScheduledAt'] as Timestamp).toDate();

  @override
  final String id;

  @override
  final String text;

  @override
  final DateTime lastStudiedAt;

  @override
  final DateTime nextStudyScheduledAt;
}
