import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import './commons/authenticatable.dart';
import './commons/card_subscribable.dart';

export './commons/authenticatable.dart';
export './commons/card_subscribable.dart';

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

abstract class CardListBloc {
  ValueObservable<Iterable<Card>> get cards;
}

class _CardListBloc implements CardListBloc {
  _CardListBloc({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable;

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  @override
  ValueObservable<Iterable<Card>> get cards =>
      _cardSubscribable.subscribeCards(user: _authenticatable.user.value);
}
