import './review_certainty.dart';

abstract class Review {
  DateTime get reviewedAt;

  ReviewCertainty get certainty;

  Duration get nextReviewInterval;

  double get maturity => calculateMaturity(nextReviewInterval);

  static double calculateMaturity(Duration nextReviewInterval) =>
      nextReviewInterval.inMilliseconds / (1000 * 60 * 60 * 24 * 365);
}
