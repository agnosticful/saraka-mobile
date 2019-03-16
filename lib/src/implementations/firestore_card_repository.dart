import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';
import './firestore_card.dart';

class FirestoreCardRepository implements CardStudyable, CardSubscribable {
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
        .orderBy('createdAt', descending: true)
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
  Future<void> study({Card card, StudyCertainty certainty, User user}) async {
    final cardReference = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .document(card.id);
    final cardSnapshot = await cardReference.get();
    final lastLearningRefernece = cardSnapshot.data['lastLearning'];

    _FirestoreLearning lastLearning;

    if (lastLearningRefernece != null) {
      final lastLearningDocument =
          await (lastLearningRefernece as DocumentReference).get();

      lastLearning = _FirestoreLearning(lastLearningDocument);
    }

    final batch = _firestore.batch();

    final newLearningReference =
        cardReference.collection("learnings").document();

    final learnedAt = DateTime.now();

    batch.updateData(cardReference, {
      "lastLearning": newLearningReference,
      "lastLearnedAt": Timestamp.fromDate(learnedAt),
      "hasToLearnAfter": Timestamp.fromDate(
          learnedAt.add(Duration(milliseconds: 1000 * 60 * 5))),
    });

    batch.setData(newLearningReference, {
      "learnedAt": Timestamp.fromDate(learnedAt),
      "intervalInMilliSecondsForNext":
          Duration(milliseconds: 1000 * 60 * 5).inMilliseconds,
      "certainty": certainty.toString(),
      "streak": lastLearning == null ? 1 : lastLearning.streak + 1,
    });

    await batch.commit();
  }
}

String idify(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'[^0-9A-Za-z]'), '-');

class _FirestoreLearning {
  _FirestoreLearning(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        learnedAt = snapshot.data['learnedAt'] == null
            ? null
            : (snapshot.data['learnedAt'] as Timestamp).toDate(),
        intervalForNext = Duration(
            milliseconds: snapshot.data['intervalInMilliSecondsForNext']),
        // certainty = StudyCertainty.parse(snapshot.data['certainty']),
        streak = snapshot.data['streak'];

  final DateTime learnedAt;

  final Duration intervalForNext;

  // final StudyCertainty certainty;

  final int streak;
}
