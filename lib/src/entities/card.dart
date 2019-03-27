import './mixins/identifiable.dart';
import './study.dart';

abstract class Card with Identifiable<Card, String> {
  String get text;

  DateTime get lastStudiedAt;

  DateTime get nextStudyScheduledAt;

  Duration get nextStudyInterval;

  double get maturity => Study.calculateMaturity(nextStudyInterval);

  bool get isScheduled => nextStudyScheduledAt.isBefore(DateTime.now());
}
