import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/maintenance_subscribable.dart';

class FirestoreMaintenanceRepository implements MaintenanceSubscribable {
  FirestoreMaintenanceRepository({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  ValueObservable<Maintenance> subscribeMaintenance() {
    final observable = BehaviorSubject<Maintenance>();

    final subscription = _firestore
        .collection('maintenances')
        .where('isProcessing', isEqualTo: true)
        .orderBy('startedAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.documents.length == 1) {
        observable.add(Maintenance(
          startedAt: (snapshot.documents[0]['startedAt'] as Timestamp).toDate(),
          finishedAt: (snapshot.documents[0]['endedAt'] as Timestamp).toDate(),
        ));
      } else {
        observable.add(null);
      }
    });

    observable.onCancel = () => subscription.cancel();

    return observable;
  }
}
