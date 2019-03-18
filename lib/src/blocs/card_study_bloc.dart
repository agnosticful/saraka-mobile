import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';

class CardStudyBlocFactory {
  CardStudyBlocFactory({
    @required Authenticatable authenticatable,
    @required CardStudyable cardStudyable,
    @required InQueueCardSubscribable inQueueCardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardStudyable != null),
        assert(inQueueCardSubscribable != null),
        _authenticatable = authenticatable,
        _cardStudyable = cardStudyable,
        _inQueueCardSubscribable = inQueueCardSubscribable;

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final InQueueCardSubscribable _inQueueCardSubscribable;

  CardStudyBloc create() => _CardStudyBloc(
        authenticatable: _authenticatable,
        cardStudyable: _cardStudyable,
        inQueueCardSubscribable: _inQueueCardSubscribable,
      );
}

abstract class CardStudyBloc {
  Observable<Iterable<Card>> get cards;

  Observable<Set<Card>> get cardsInQueue;

  Observable<double> get finishedRatio;

  void studiedWell(Card card);

  void studiedVaguely(Card card);
}

class _CardStudyBloc implements CardStudyBloc {
  _CardStudyBloc({
    @required Authenticatable authenticatable,
    @required CardStudyable cardStudyable,
    @required InQueueCardSubscribable inQueueCardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardStudyable != null),
        assert(inQueueCardSubscribable != null),
        _authenticatable = authenticatable,
        _cardStudyable = cardStudyable,
        _inQueueCardSubscribable = inQueueCardSubscribable;

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final InQueueCardSubscribable _inQueueCardSubscribable;

  final BehaviorSubject<LinkedHashSet<Card>> _studiedCards =
      BehaviorSubject.seeded(LinkedHashSet());

  @override
  Observable<Iterable<Card>> get cards => Observable.combineLatest2(
        _inQueueCardSubscribable.subscribeInQueueCards(
            user: _authenticatable.user.value),
        _studiedCards,
        (cards, studiedCards) =>
            LinkedHashSet()..addAll(studiedCards)..addAll(cards),
      );

  @override
  Observable<LinkedHashSet<Card>> get cardsInQueue => Observable.combineLatest2(
        cards,
        _studiedCards,
        (cards, studiedCards) =>
            cards.where((card) => !studiedCards.contains(card)),
      );

  @override
  Observable<double> get finishedRatio => Observable.combineLatest2(
        cards,
        _studiedCards,
        (cards, studiedCards) =>
            cards.length > 0 ? studiedCards.length / cards.length : 0,
      );

  @override
  Future<void> studiedWell(Card card) async {
    _studiedCards.add(LinkedHashSet.of(_studiedCards.value)..add(card));

    await _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.good,
      user: _authenticatable.user.value,
    );
  }

  @override
  Future<void> studiedVaguely(Card card) async {
    _studiedCards.add(LinkedHashSet.of(_studiedCards.value)..add(card));

    await _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.vague,
      user: _authenticatable.user.value,
    );
  }
}

enum StudyCertainty {
  good,
  vague,
}

mixin CardStudyable {
  Future<void> study({
    @required Card card,
    @required StudyCertainty certainty,
    @required User user,
  });
}

mixin InQueueCardSubscribable {
  Observable<Iterable<Card>> subscribeInQueueCards({@required User user});
}

class StudyDuplicationException implements Exception {
  StudyDuplicationException(this.card);

  final Card card;

  String toString() =>
      'StudyDuplicationException: `${card.id}` has been just studied..';
}
