import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

abstract class CardCreateBloc {
  Future<void> create(String text);

  void initialize();

  void dispose();
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.text);

  final String text;

  String toString() => 'CardDuplicationException: `$text` already exists.';
}

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
