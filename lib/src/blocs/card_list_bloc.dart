import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';
import './card_subscribable.dart';
export '../entities/card.dart';

abstract class CardListBloc {
  ValueObservable<List<Card>> get cards;
}

class _CardListBloc implements CardListBloc {
  _CardListBloc({
    @required this.cardSubscribable,
    @required this.session,
  })  : assert(cardSubscribable != null),
        assert(session != null);

  final CardSubscribable cardSubscribable;

  final AuthenticationSession session;

  @override
  BehaviorSubject<List<Card>> get cards =>
      cardSubscribable.subscribeCards(session: session);
}

class CardListBlocFactory {
  CardListBlocFactory({@required CardSubscribable cardSubscribable})
      : assert(cardSubscribable != null),
        _cardSubscribable = cardSubscribable;

  final CardSubscribable _cardSubscribable;

  CardListBloc create({@required AuthenticationSession session}) =>
      _CardListBloc(
        cardSubscribable: _cardSubscribable,
        session: session,
      );
}
