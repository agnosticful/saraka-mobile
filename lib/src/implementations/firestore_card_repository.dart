import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/blocs.dart';
import './firestore_card.dart';

class FirestoreCardRepository implements CardSubscribable {
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
}

String idify(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'[^0-9A-Za-z]'), '-');
