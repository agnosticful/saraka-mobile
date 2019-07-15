import 'package:meta/meta.dart';
import 'package:saraka/behaviors.dart';
import 'package:saraka/entities.dart';

abstract class CardDeleteBloc {
  Card get card;

  Future<void> delete();
}

class _CardDeleteBloc implements CardDeleteBloc {
  _CardDeleteBloc({
    @required this.card,
    @required this.cardDeletable,
    @required this.session,
  })  : assert(card != null),
        assert(cardDeletable != null),
        assert(session != null);

  @override
  final Card card;

  final CardDeletable cardDeletable;

  final AuthenticationSession session;

  @override
  Future<void> delete() => cardDeletable.deleteCard(
        card: card,
        session: session,
      );
}

class CardDeleteBlocFactory {
  CardDeleteBlocFactory({@required CardDeletable cardDeletable})
      : assert(cardDeletable != null),
        _cardDeletable = cardDeletable;

  final CardDeletable _cardDeletable;

  CardDeleteBloc create({
    @required Card card,
    @required AuthenticationSession session,
  }) =>
      _CardDeleteBloc(
        card: card,
        cardDeletable: _cardDeletable,
        session: session,
      );
}
