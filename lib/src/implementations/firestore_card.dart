import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saraka/blocs.dart';

class FirestoreCard extends Card {
  FirestoreCard(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        text = snapshot.data['text'],
        lastLearnedAt = snapshot.data['lastLearnedAt'] == null
            ? null
            : (snapshot.data['lastLearnedAt'] as Timestamp).toDate(),
        hasToLearnAfter = snapshot.data['hasToLearnAfter'] == null
            ? null
            : (snapshot.data['hasToLearnAfter'] as Timestamp).toDate();

  @override
  final String id;

  @override
  final String text;

  @override
  final DateTime lastLearnedAt;

  @override
  final DateTime hasToLearnAfter;
}
