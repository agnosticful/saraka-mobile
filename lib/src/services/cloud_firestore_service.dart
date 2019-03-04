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
  Future<void> addNewCard({@required User user, @required String text}) async {
    final document = _firestore
        .collection('users')
        .document(user.id)
        .collection('cards')
        .document();

    await document.setData({
      "text": text,
    });
  }
}
