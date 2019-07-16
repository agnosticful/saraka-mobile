import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';
import '../blocs/card_create_bloc.dart';

class CardCreateService implements CardCreatable {
  CardCreateService({@required CloudFunctions cloudFunctions})
      : assert(cloudFunctions != null),
        _createCardFunction =
            cloudFunctions.getHttpsCallable(functionName: 'createCard');

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
}
