import 'package:meta/meta.dart';
import '../blocs/card_create_bloc.dart';
import '../entities/authentication_session.dart';

export '../entities/authentication_session.dart';

class CardCreateBlocFactory {
  CardCreateBlocFactory({
    @required CardCreatable cardCreatable,
  })  : assert(cardCreatable != null),
        _cardCreatable = cardCreatable;

  final CardCreatable _cardCreatable;

  CardCreateBloc create({@required AuthenticationSession session}) =>
      _CardCreateBloc(
        session: session,
        cardCreatable: _cardCreatable,
      );
}

abstract class CardCreatable {
  Future<void> createCard({
    @required AuthenticationSession session,
    @required String text,
  });
}

class _CardCreateBloc implements CardCreateBloc {
  _CardCreateBloc({
    @required this.cardCreatable,
    @required this.session,
  })  : assert(cardCreatable != null),
        assert(session != null);

  final CardCreatable cardCreatable;

  final AuthenticationSession session;

  @override
  Future<void> create(String text) => cardCreatable.createCard(
        session: session,
        text: text,
      );

  @override
  void initialize() {}

  @override
  void dispose() {}
}
