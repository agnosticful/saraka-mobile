import './mixins/identifiable.dart';

abstract class Card with Identifiable<Card, String> {
  String get text;

  DateTime get lastLearnedAt;

  DateTime get hasToLearnAfter;

  bool get hasToLearn => hasToLearnAfter.isBefore(DateTime.now());
}
