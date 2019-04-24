import './mixins/identifiable.dart';
import './review.dart';

abstract class Card with Identifiable<Card, String> {
  String get text;

  DateTime get lastReviewedAt;

  DateTime get nextReviewScheduledAt;

  Duration get nextReviewInterval;

  double get proficiency => Review.calculateProficiency(nextReviewInterval);

  bool get isScheduled => nextReviewScheduledAt.isBefore(DateTime.now());

  double get modifier;
}
