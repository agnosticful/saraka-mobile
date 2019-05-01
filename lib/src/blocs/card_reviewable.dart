import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';
import '../entities/review_certainty.dart';
export '../entities/authentication_session.dart';
export '../entities/card.dart';
export '../entities/review_certainty.dart';

mixin CardReviewable {
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
