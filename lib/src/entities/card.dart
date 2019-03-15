import './mixins/identifiable.dart';

abstract class Card with Identifiable<Card, String> {
  String get text;

  DateTime get lastStudiedAt;

  DateTime get nextStudyScheduledAt;

  bool get isScheduled => nextStudyScheduledAt.isBefore(DateTime.now());
}
