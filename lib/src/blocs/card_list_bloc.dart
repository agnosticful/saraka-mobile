import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';
import './authenticatable.dart';
import './card_subscribable.dart';
export '../entities/card.dart';

abstract class CardListBloc {
  ValueObservable<List<Card>> get cards;
}

class _CardListBloc implements CardListBloc {
  _CardListBloc({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable {
    _cardSubscribable
        .subscribeCards(user: _authenticatable.user.value)
        .listen((cs) {
      cards.add(cs);
    });
  }

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  @override
  final BehaviorSubject<List<Card>> cards = BehaviorSubject();
}

class CardListBlocFactory {
  CardListBlocFactory({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable;

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  CardListBloc create() => _CardListBloc(
        authenticatable: _authenticatable,
        cardSubscribable: _cardSubscribable,
      );
}
