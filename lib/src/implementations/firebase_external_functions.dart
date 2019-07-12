import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:saraka/behaviors.dart';
import 'package:saraka/entities.dart';

class FirebaseExternalFunctions
    implements CardCreatable, CardReviewable, Synthesizable {
  FirebaseExternalFunctions({
    @required CloudFunctions cloudFunctions,
  })  : assert(cloudFunctions != null),
        _createCardFunction =
            cloudFunctions.getHttpsCallable(functionName: 'createCard'),
        _logReviewFunction =
            cloudFunctions.getHttpsCallable(functionName: 'logReview'),
        _deleteLastReviewFunction =
            cloudFunctions.getHttpsCallable(functionName: 'deleteLastReview'),
        _synthesizeFunction =
            cloudFunctions.getHttpsCallable(functionName: 'synthesize');

  final HttpsCallable _createCardFunction;

  final HttpsCallable _logReviewFunction;

  final HttpsCallable _deleteLastReviewFunction;

  final HttpsCallable _synthesizeFunction;

  @override
  Future<void> add({AuthenticationSession session, NewCardText text}) async {
    try {
      await _createCardFunction({"text": text.text});
    } on CloudFunctionsException catch (error) {
      if (error.code == "ALREADY_EXISTS") {
        throw CardDuplicationException(text.text);
      }

      rethrow;
    }
  }

  @override
  Future<void> review({
    Card card,
    ReviewCertainty certainty,
    AuthenticationSession session,
  }) async {
    try {
      await _logReviewFunction({
        "cardId": card.id,
        "certainty": certainty.toString(),
      });
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewDuplicationException(card);
      }
    }
  }

  @override
  Future<void> undoReview({Card card, AuthenticationSession session}) async {
    try {
      await _deleteLastReviewFunction({"cardId": card.id});
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewOverundoException(card);
      }
    }
  }

  @override
  Future<List<int>> synthesize(String text) async {
    final result = await _synthesizeFunction({
      "text": text,
    });

    return base64.decode(result.data);
  }
}
