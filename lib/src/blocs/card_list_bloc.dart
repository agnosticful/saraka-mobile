import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/behaviors.dart';
import 'package:saraka/entities.dart';

abstract class CardListBloc {
  ValueObservable<List<Card>> get cards;

  // ValueObservable<List<Card>> get cardsReady;

  // ValueObservable<List<Card>> get cardsUpcoming;
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
      cardSubscribable.subscribeAllCards(session: session);

  // @override
  // ValueObservable<List<Card>> get cardsReady =>
  //     cardSubscribable.subscribeReadyCards(session: session);

  // @override
  // ValueObservable<List<Card>> get cardsUpcoming =>
  //     cardSubscribable.subscribeUpcomingCards(session: session);
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
