import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

abstract class CardReviewable {
  Future<void> review({
    @required AuthenticationSession session,
    @required Card card,
    @required ReviewCertainty certainty,
  });

  Future<void> undoReview({
    @required AuthenticationSession session,
    @required Card card,
  });
}

class ReviewDuplicationException implements Exception {
  ReviewDuplicationException(this.card);

  final Card card;

  String toString() =>
      'ReviewDuplicationException: `${card.id}` has been just reviewed.';
}

class ReviewOverundoException implements Exception {
  ReviewOverundoException(this.card);

  final Card card;

  String toString() =>
      'ReviewOverundoException: `${card.id}` doesn\'t have review to undo.';
}
