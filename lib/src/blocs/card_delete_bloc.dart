import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/behaviors.dart';
import 'package:saraka/entities.dart';

abstract class CardDeleteBloc {
  Card get card;

  ValueObservable<CardDeletionState> get state;

  Observable<void> get onComplete;

  Observable<Exception> get onError;

  void delete();
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

  final _state =
      BehaviorSubject<CardDeletionState>.seeded(CardDeletionState.initial);

  ValueObservable<CardDeletionState> get state => _state;

  final _onComplete = BehaviorSubject<void>();

  @override
  Observable<void> get onComplete => _onComplete;

  final _onError = BehaviorSubject<Exception>();

  @override
  Observable<Exception> get onError => _onError;

  @override
  void delete() async {
    _state.add(CardDeletionState.processing);

    try {
      await cardDeletable.deleteCard(
        card: card,
        session: session,
      );
    } catch (error) {
      _state.add(CardDeletionState.failed);
      _onError.add(error);

      return;
    }

    _state.add(CardDeletionState.completed);
    _onComplete.add(null);
  }
}

enum CardDeletionState {
  initial,
  processing,
  completed,
  failed,
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
