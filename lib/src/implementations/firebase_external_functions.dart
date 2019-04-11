import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:saraka/blocs.dart';

class FirebaseExternalFunctions
    implements CardAddable, CardReviewable, Synthesizable {
  FirebaseExternalFunctions({
    @required CloudFunctions cloudFunctions,
  })  : assert(cloudFunctions != null),
        _cloudFunctions = cloudFunctions;

  final CloudFunctions _cloudFunctions;

  @override
  Future<void> add({User user, NewCardText text}) async {
    try {
      await _cloudFunctions.call(
        functionName: 'createCard',
        parameters: {
          "text": text.text,
        },
      );
    } on CloudFunctionsException catch (error) {
      if (error.code == "ALREADY_EXISTS") {
        throw CardDuplicationException(text.text);
      }

      rethrow;
    }
  }

  @override
  Future<void> review({Card card, ReviewCertainty certainty, User user}) async {
    try {
      await _cloudFunctions.call(
        functionName: 'logReview',
        parameters: {
          "cardId": card.id,
          "certainty": certainty.toString(),
        },
      );
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewDuplicationException(card);
      }
    }
  }

  @override
  Future<void> undoReview({Card card, User user}) async {
    try {
      await _cloudFunctions.call(
        functionName: 'deleteLastReview',
        parameters: {
          "cardId": card.id,
        },
      );
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewOverundoException(card);
      }
    }
  }

  @override
  Future<List<int>> synthesize(String text) async {
    final audioBase64 = await _cloudFunctions.call(
      functionName: 'synthesize',
      parameters: {
        "text": text,
      },
    );

    return base64.decode(audioBase64);
  }
}
