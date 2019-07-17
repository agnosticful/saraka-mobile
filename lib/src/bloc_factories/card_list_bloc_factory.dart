import 'dart:async';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/card_list_bloc.dart';
import '../entities/authentication_session.dart';

export '../entities/authentication_session.dart';
export '../entities/card.dart';

class CardListBlocFactory {
  CardListBlocFactory({@required CardListable cardListable})
      : assert(cardListable != null),
        _cardListable = cardListable;

  final CardListable _cardListable;

  CardListBloc create({@required AuthenticationSession session}) =>
      _CardListBloc(
        cardListable: _cardListable,
        session: session,
      );
}

abstract class CardListable {
  Observable<List<Card>> subscribeCards({
    @required AuthenticationSession session,
  });
}

class _CardListBloc implements CardListBloc {
  _CardListBloc({
    @required this.cardListable,
    @required this.session,
  })  : assert(cardListable != null),
        assert(session != null),
        cards = ValueConnectableObservable(
            cardListable.subscribeCards(session: session));

  final CardListable cardListable;

  final AuthenticationSession session;

  StreamSubscription _reviewsSubscription;

  @override
  final ValueConnectableObservable<List<Card>> cards;

  @override
  void initialize() {
    _reviewsSubscription = cards.connect();
  }

  @override
  void dispose() {
    _reviewsSubscription?.cancel();
  }
}
