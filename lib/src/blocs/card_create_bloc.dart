import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../behaviors/card_creatable.dart';
import '../behaviors/card_create_loggable.dart';
import '../entities/authentication_session.dart';
import '../entities/new_card_text.dart';

abstract class CardCreateBloc {
  ValueObservable<NewCardText> get text;

  ValueObservable<CardAddingState> get state;

  Observable<void> get onComplete;

  Observable<Exception> get onError;

  void setText(String text);

  void save();

  void initialize();
}

class _CardCreateBloc implements CardCreateBloc {
  _CardCreateBloc({
    @required this.cardCreatable,
    @required this.cardCreateLoggable,
    @required this.session,
  })  : assert(cardCreatable != null),
        assert(cardCreateLoggable != null),
        assert(session != null);

  final CardCreatable cardCreatable;

  final CardCreateLoggable cardCreateLoggable;

  final AuthenticationSession session;

  final _text = BehaviorSubject<NewCardText>.seeded(_NewCardText(""));

  @override
  BehaviorSubject<NewCardText> get text => _text;

  final _state =
      BehaviorSubject<CardAddingState>.seeded(CardAddingState.initial);

  @override
  ValueObservable<CardAddingState> get state => _state;

  final _onComplete = BehaviorSubject<void>();

  @override
  Observable<void> get onComplete => _onComplete;

  final _onError = BehaviorSubject<Exception>();

  @override
  Observable<Exception> get onError => _onError;

  @override
  void setText(String newText) => _text.add(_NewCardText(newText));

  @override
  Future<void> save() async {
    assert(text.value.isValid);

    _state.add(CardAddingState.processing);

    try {
      await cardCreatable.add(
        session: session,
        text: text.value,
      );

      await cardCreateLoggable.logCardCreate();
    } on CardDuplicationException catch (error) {
      _state.add(CardAddingState.failed);
      _onError.add(error);

      return;
    } catch (error) {
      _state.add(CardAddingState.failed);
      _onError.add(error);

      return;
    }

    _state.add(CardAddingState.completed);
    _onComplete.add(null);
  }

  @override
  void initialize() {
    cardCreateLoggable.logCardCreateStart();
  }
}

enum CardAddingState {
  initial,
  processing,
  completed,
  failed,
}

class _NewCardText extends NewCardText {
  _NewCardText(this.text) : assert(text != null);

  @override
  final String text;
}

class CardCreateBlocFactory {
  CardCreateBlocFactory({
    @required CardCreatable cardCreatable,
    @required CardCreateLoggable cardCreateLoggable,
  })  : assert(cardCreatable != null),
        assert(cardCreateLoggable != null),
        _cardCreatable = cardCreatable,
        _cardCreateLoggable = cardCreateLoggable;

  final CardCreatable _cardCreatable;

  final CardCreateLoggable _cardCreateLoggable;

  CardCreateBloc create({@required AuthenticationSession session}) =>
      _CardCreateBloc(
        session: session,
        cardCreatable: _cardCreatable,
        cardCreateLoggable: _cardCreateLoggable,
      );
}
