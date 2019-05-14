import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import '../blocs/card_addable.dart';
import '../blocs/card_reviewable.dart';
import '../blocs/synthesizable.dart';

class FirebaseExternalFunctions
    implements CardAddable, CardReviewable, Synthesizable {
  FirebaseExternalFunctions({
    @required CloudFunctions cloudFunctions,
  })  : assert(cloudFunctions != null),
        _cloudFunctions = cloudFunctions;

  final CloudFunctions _cloudFunctions;

  @override
  Future<void> add({AuthenticationSession session, NewCardText text}) async {
    try {
      await _cloudFunctions.getHttpsCallable(
        functionName: 'createCard',
        parameters: {
          "text": text.text,
        },
      )();
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
      await _cloudFunctions.getHttpsCallable(
        functionName: 'logReview',
        parameters: {
          "cardId": card.id,
          "certainty": certainty.toString(),
        },
      )();
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewDuplicationException(card);
      }
    }
  }

  @override
  Future<void> undoReview({Card card, AuthenticationSession session}) async {
    try {
      await _cloudFunctions.getHttpsCallable(
        functionName: 'deleteLastReview',
        parameters: {
          "cardId": card.id,
        },
      )();
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewOverundoException(card);
      }
    }
  }

  @override
  Future<List<int>> synthesize(String text) async {
    final result = await _cloudFunctions.getHttpsCallable(
      functionName: 'synthesize',
      parameters: {
        "text": text,
      },
    )();

    return base64.decode(result.data);
  }
}
