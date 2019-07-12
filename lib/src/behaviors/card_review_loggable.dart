import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

abstract class CardReviewLoggable {
  Future<void> logReviewStart({@required int cardLength});

  Future<void> logReviewEnd({
    @required int cardLength,
    @required int reviewedCardLength,
  });

  Future<void> logCardReview({@required ReviewCertainty certainty});

  Future<void> logCardReviewUndo();
}
