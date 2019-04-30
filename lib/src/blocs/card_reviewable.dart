import 'package:meta/meta.dart';
import 'package:saraka/entities.dart' show Card, ReviewCertainty, User;
export 'package:saraka/entities.dart' show Card, ReviewCertainty, User;

mixin CardReviewable {
  Future<void> review({
    @required Card card,
    @required ReviewCertainty certainty,
    @required User user,
  });

  Future<void> undoReview({
    @required Card card,
    @required User user,
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
