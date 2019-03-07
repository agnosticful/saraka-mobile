import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class CloudFirestoreService implements RepositoryService {
  CloudFirestoreService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  Stream<List<Card>> subscribeCards({@required User user}) => _firestore
      .collection('users')
      .document(user.id)
      .collection('cards')
      .orderBy('createdAt', descending: true)
      .limit(1000)
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map((document) => _FirestoreCard(
                document,
                user: user,
                repositoryService: this,
              ))
          .toList());

  @override
  Future<void> addNewCard({@required User user, @required String text}) async {
    final document = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .document(idify(text));

    if ((await document.get()).exists) {
      throw new CardDuplicationException(text);
    }

    await document.setData({
      "text": text,
      "createdAt": FieldValue.serverTimestamp(),
      "lastLearning": null,
      "lastLearnedAt": null,
      "hasToLearnAfter": FieldValue.serverTimestamp(),
    });
  }

  Future<void> logLearning({
    @required User user,
    @required Card card,
    @required Duration interval,
    @required LearningCertainty certainty,
  }) async {
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
      "hasToLearnAfter": Timestamp.fromDate(learnedAt.add(interval)),
    });

    batch.setData(newLearningReference, {
      "learnedAt": Timestamp.fromDate(learnedAt),
      "intervalInMilliSecondsForNext": interval.inMilliseconds,
      "certainty": certainty.toString(),
      "streak": lastLearning == null ? 1 : lastLearning.streak + 1,
    });

    await batch.commit();
  }

  Future<void> undoLearning({
    @required User user,
    @required Card card,
  }) async {
    final learningDocuments = (await _firestore
            .collection('users')
            .document(user.id)
            .collection('cards')
            .document(card.id)
            .collection("learnings")
            .orderBy('learnedAt', descending: true)
            .limit(1)
            .getDocuments())
        .documents;

    assert(learningDocuments.length == 1);

    await learningDocuments.last.reference.delete();
  }
}

String idify(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'[^0-9A-Za-z]'), '-');

class _FirestoreCard extends Card {
  _FirestoreCard(
    DocumentSnapshot snapshot, {
    @required User user,
    @required RepositoryService repositoryService,
  })  : assert(snapshot != null),
        assert(user != null),
        assert(repositoryService != null),
        id = snapshot.documentID,
        text = snapshot.data['text'],
        lastLearnedAt = snapshot.data['lastLearnedAt'] == null
            ? null
            : (snapshot.data['lastLearnedAt'] as Timestamp).toDate(),
        hasToLearnAfter = snapshot.data['hasToLearnAfter'] == null
            ? null
            : (snapshot.data['hasToLearnAfter'] as Timestamp).toDate(),
        _user = user,
        _repositoryService = repositoryService;

  final User _user;

  final RepositoryService _repositoryService;

  @override
  final String id;

  @override
  final String text;

  @override
  final DateTime lastLearnedAt;

  @override
  final DateTime hasToLearnAfter;

  @override
  Future<void> logLearning(
    LearningCertainty certainty,
    Duration interval,
  ) async {
    await _repositoryService.logLearning(
      user: _user,
      card: this,
      certainty: certainty,
      interval: interval,
    );
  }

  @override
  Future<void> undoLearning() async {}
}

class _FirestoreLearning {
  _FirestoreLearning(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        learnedAt = snapshot.data['learnedAt'] == null
            ? null
            : (snapshot.data['learnedAt'] as Timestamp).toDate(),
        intervalForNext = Duration(
            milliseconds: snapshot.data['intervalInMilliSecondsForNext']),
        certainty = LearningCertainty.parse(snapshot.data['certainty']),
        streak = snapshot.data['streak'];

  final DateTime learnedAt;

  final Duration intervalForNext;

  final LearningCertainty certainty;

  final int streak;
}
