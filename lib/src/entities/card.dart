import './mixins/identifiable.dart';
import './review.dart';

abstract class Card with Identifiable<Card, String> {
  String get text;

  DateTime get lastReviewedAt;

  DateTime get nextReviewScheduledAt;

  Duration get nextReviewInterval;

  double get maturity => Review.calculateMaturity(nextReviewInterval);

  bool get isScheduled => nextReviewScheduledAt.isBefore(DateTime.now());
}
