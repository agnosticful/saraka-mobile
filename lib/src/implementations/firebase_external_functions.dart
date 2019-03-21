import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import 'package:saraka/blocs.dart';

class FirebaseExternalFunctions
    implements CardAddable, CardStudyable, Synthesizable {
  FirebaseExternalFunctions({
    @required CloudFunctions cloudFunctions,
  })  : assert(cloudFunctions != null),
        _cloudFunctions = cloudFunctions;

  final CloudFunctions _cloudFunctions;

  @override
  Future<void> add({User user, NewCardText text}) async {
    try {
      await _cloudFunctions
          .call(functionName: 'createCard', parameters: {"text": text.text});
    } on CloudFunctionsException catch (error) {
      if (error.code == "ALREADY_EXISTS") {
        throw CardDuplicationException(text.text);
      }

      rethrow;
    }
  }

  @override
  Future<void> study({Card card, StudyCertainty certainty, User user}) async {
    try {
      await _cloudFunctions.call(functionName: 'logStudy', parameters: {
        "cardId": card.id,
        "certainty": buildCertaintyString(certainty),
      });
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw StudyDuplicationException(card);
      }
    }
  }

  @override
  Future<void> undoStudy({Card card, User user}) async {
    try {
      await _cloudFunctions.call(functionName: 'deleteLastStudy', parameters: {
        "cardId": card.id,
      });
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw StudyOverundoException(card);
      }
    }
  }

  @override
  Future<List<int>> synthesize(String text) async {
    final audioBase64 = await _cloudFunctions
        .call(functionName: 'synthesize', parameters: {"text": text});

    return base64.decode(audioBase64);
  }
}

String buildCertaintyString(StudyCertainty certainty) {
  switch (certainty) {
    case StudyCertainty.good:
      return "GOOD";
    case StudyCertainty.vague:
      return "VAGUE";
  }

  assert(false);
}
