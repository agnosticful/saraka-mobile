import './review_certainty.dart';

export './review_certainty.dart';

abstract class Review {
  DateTime get reviewedAt;

  ReviewCertainty get certainty;

  Duration get nextReviewInterval;

  double get proficiency => calculateProficiency(nextReviewInterval);

  static double calculateProficiency(Duration nextReviewInterval) =>
      nextReviewInterval.inMilliseconds / (1000 * 60 * 60 * 24 * 365);
}
