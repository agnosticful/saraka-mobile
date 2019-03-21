import 'dart:convert' show base64;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import 'package:saraka/blocs.dart';

class TrackedFirebaseExternalFunctions
    implements CardAddable, CardStudyable, Synthesizable {
  TrackedFirebaseExternalFunctions({
    @required FirebaseAnalytics firebaseAnalytics,
    @required CloudFunctions cloudFunctions,
  })  : assert(firebaseAnalytics != null),
        assert(cloudFunctions != null),
        _firebaseAnalytics = firebaseAnalytics,
        _cloudFunctions = cloudFunctions;

  final FirebaseAnalytics _firebaseAnalytics;

  final CloudFunctions _cloudFunctions;

  @override
  Future<void> add({User user, NewCardText text}) async {
    try {
      await _cloudFunctions
          .call(functionName: 'createCard', parameters: {"text": text.text});

      _firebaseAnalytics.logEvent(name: 'card_create');
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

      _firebaseAnalytics.logEvent(
        name: 'card_study',
        parameters: {"certainty": buildCertaintyString(certainty)},
      );
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw StudyDuplicationException(card);
      }
    }
  }

  @override
  Future<List<int>> synthesize(String text) async {
    final audioBase64 = await _cloudFunctions
        .call(functionName: 'synthesize', parameters: {"text": text});

    _firebaseAnalytics.logEvent(name: 'synthesize');

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
