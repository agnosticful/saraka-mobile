import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';
import './commons/card_subscribable.dart';

export 'package:saraka/entities.dart' show Card;

class CardStudyBlocFactory {
  CardStudyBlocFactory({
    @required Authenticatable authenticatable,
    @required CardStudyable cardStudyable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardStudyable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardStudyable = cardStudyable,
        _cardSubscribable = cardSubscribable;

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final CardSubscribable _cardSubscribable;

  CardStudyBloc create() => _CardStudyBloc(
        authenticatable: _authenticatable,
        cardStudyable: _cardStudyable,
        cardSubscribable: _cardSubscribable,
      );
}

abstract class CardStudyBloc {
  ValueObservable<Iterable<Card>> get cards;

  void studiedWell(Card card);

  void studiedVaguely(Card card);
}

class _CardStudyBloc implements CardStudyBloc {
  _CardStudyBloc({
    @required Authenticatable authenticatable,
    @required CardStudyable cardStudyable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardStudyable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardStudyable = cardStudyable,
        _cardSubscribable = cardSubscribable {
    _cardSubscribable
        .subscribeCards(user: _authenticatable.user.value)
        .first
        .then((cards) => _cards.add(cards));
  }

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final CardSubscribable _cardSubscribable;

  final BehaviorSubject<Iterable<Card>> _cards = BehaviorSubject();

  @override
  ValueObservable<Iterable<Card>> get cards => _cards;

  @override
  Future<void> studiedWell(Card card) async {
    _cards.add(_cards.value.where((c) => c != card));

    await _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.good,
      user: _authenticatable.user.value,
    );
  }

  @override
  Future<void> studiedVaguely(Card card) async {
    _cards.add(_cards.value.where((c) => c != card));

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

class StudyDuplicationException implements Exception {
  StudyDuplicationException(this.card);

  final Card card;

  String toString() =>
      'StudyDuplicationException: `${card.id}` has been just studied..';
}
