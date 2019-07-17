import 'package:meta/meta.dart';
import '../blocs/card_delete_bloc.dart';
import '../entities/authentication_session.dart';

export '../entities/authentication_session.dart';
export '../entities/card.dart';

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

abstract class CardDeletable {
  Future<void> deleteCard({
    @required Card card,
    @required AuthenticationSession session,
  });
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

  @override
  void initialize() {}

  @override
  void dispose() {}
}
