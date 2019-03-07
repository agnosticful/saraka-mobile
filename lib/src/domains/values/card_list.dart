import 'package:saraka/domains.dart';

abstract class CardList {
  Stream<List<Card>> get cards;

  Stream<Iterable<Card>> get cardsInQueue =>
      cards.map((_cards) => _cards.where((card) => card.hasToStudy));

  Stream<Iterable<Card>> get cardsNotInQueue =>
      cards.map((_cards) => _cards.where((card) => !card.hasToStudy));
}
