import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';
import '../bloc_factories/card_review_bloc_factory.dart';

class ReviewCommandService implements CardReviewable {
  ReviewCommandService({
    @required CloudFunctions cloudFunctions,
  })  : assert(cloudFunctions != null),
        _logReviewFunction =
            cloudFunctions.getHttpsCallable(functionName: 'logReview'),
        _deleteLastReviewFunction =
            cloudFunctions.getHttpsCallable(functionName: 'deleteLastReview');

  final HttpsCallable _logReviewFunction;

  final HttpsCallable _deleteLastReviewFunction;

  @override
  Future<void> review({
    @required AuthenticationSession session,
    @required Card card,
    @required ReviewCertainty certainty,
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
  Future<void> undoReview({
    @required AuthenticationSession session,
    @required Card card,
  }) async {
    try {
      await _deleteLastReviewFunction({"cardId": card.id});
    } on CloudFunctionsException catch (error) {
      if (error.code == "FAILED_PRECONDITION") {
        throw ReviewOverundoException(card);
      }
    }
  }
}
