import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';
import './commons/card_subscribable.dart';

export 'package:saraka/entities.dart' show Card;

class CardLearningBlocFactory {
  CardLearningBlocFactory({
    @required Authenticatable authenticatable,
    @required CardLearneable cardLearnable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardLearnable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardLearnable = cardLearnable,
        _cardSubscribable = cardSubscribable;

  final Authenticatable _authenticatable;

  final CardLearneable _cardLearnable;

  final CardSubscribable _cardSubscribable;

  CardLearningBloc create() => _CardLearningBloc(
        authenticatable: _authenticatable,
        cardLearnable: _cardLearnable,
        cardSubscribable: _cardSubscribable,
      );
}

abstract class CardLearningBloc {
  ValueObservable<Iterable<Card>> get cards;

  void learnedWell(Card card);

  void learnedVaguely(Card card);
}

class _CardLearningBloc implements CardLearningBloc {
  _CardLearningBloc({
    @required Authenticatable authenticatable,
    @required CardLearneable cardLearnable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardLearnable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardLearnable = cardLearnable,
        _cardSubscribable = cardSubscribable {
    _cardSubscribable
        .subscribeCards(user: _authenticatable.user.value)
        .first
        .then((cards) => _cards.add(cards));
  }

  final Authenticatable _authenticatable;

  final CardLearneable _cardLearnable;

  final CardSubscribable _cardSubscribable;

  final BehaviorSubject<Iterable<Card>> _cards = BehaviorSubject();

  @override
  ValueObservable<Iterable<Card>> get cards => _cards;

  @override
  Future<void> learnedWell(Card card) async {
    _cards.add(_cards.value.where((c) => c != card));

    await _cardLearnable.learn(
      card: card,
      certainty: LearningCertainty.good,
      user: _authenticatable.user.value,
    );
  }

  @override
  Future<void> learnedVaguely(Card card) async {
    _cards.add(_cards.value.where((c) => c != card));

    await _cardLearnable.learn(
      card: card,
      certainty: LearningCertainty.vague,
      user: _authenticatable.user.value,
    );
  }
}

enum LearningCertainty {
  good,
  vague,
}

mixin CardLearneable {
  Future<void> learn({
    @required Card card,
    @required LearningCertainty certainty,
    @required User user,
  });
}
