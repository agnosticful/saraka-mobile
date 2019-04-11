import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';

export 'package:saraka/entities.dart' show Review;

class CardDeleteBlocFactory {
  CardDeleteBlocFactory({
    @required Authenticatable authenticatable,
    @required CardDeletable cardDeletable,
  })  : assert(authenticatable != null),
        assert(cardDeletable != null),
        _authenticatable = authenticatable,
        _cardDeletable = cardDeletable;

  final Authenticatable _authenticatable;

  final CardDeletable _cardDeletable;

  CardDeleteBloc create({@required Card card}) => _CardDeleteBloc(
        card: card,
        authenticatable: _authenticatable,
        cardDeletable: _cardDeletable,
      );
}

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
    @required Authenticatable authenticatable,
    @required CardDeletable cardDeletable,
  })  : assert(card != null),
        assert(authenticatable != null),
        assert(cardDeletable != null),
        _authenticatable = authenticatable,
        _cardDeletable = cardDeletable;

  @override
  final Card card;

  final Authenticatable _authenticatable;

  final CardDeletable _cardDeletable;

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
      await _cardDeletable.deleteCard(
        user: _authenticatable.user.value,
        card: card,
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

mixin CardDeletable {
  Future<void> deleteCard({
    @required User user,
    @required Card card,
  });
}
