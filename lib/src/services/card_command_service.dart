import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import '../bloc_factories/card_delete_bloc_factory.dart';
import '../blocs/card_create_bloc.dart';
import '../bloc_factories/card_create_bloc_factory.dart';

class CardCommandService implements CardCreatable, CardDeletable {
  CardCommandService({
    @required CloudFunctions cloudFunctions,
    @required Firestore firestore,
  })  : assert(cloudFunctions != null),
        assert(firestore != null),
        _createCardFunction =
            cloudFunctions.getHttpsCallable(functionName: 'createCard'),
        _firestore = firestore;

  final Firestore _firestore;

  final HttpsCallable _createCardFunction;

  Future<void> createCard({
    @required AuthenticationSession session,
    @required String text,
  }) async {
    try {
      await _createCardFunction({"text": text});
    } on CloudFunctionsException catch (error) {
      if (error.code == "ALREADY_EXISTS") {
        throw CardDuplicationException(text);
      }

      // TODO(axross): handle any other error

      rethrow;
    }
  }

  @override
  Future<void> deleteCard({Card card, AuthenticationSession session}) =>
      Future.wait([
        Future.delayed(Duration(milliseconds: 600)),
        _firestore
            .collection('users')
            .document(session.userId)
            .collection('cards')
            .document(card.id)
            .delete(),
      ]);
}
