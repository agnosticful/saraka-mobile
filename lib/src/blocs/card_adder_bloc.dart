import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';
import './card_addable.dart';
import './card_create_loggable.dart';
export '../entities/authentication_session.dart';
export './card_addable.dart' show NewCardText;

abstract class CardAdderBloc {
  ValueObservable<NewCardText> get text;

  ValueObservable<CardAddingState> get state;

  Observable<void> get onComplete;

  Observable<Exception> get onError;

  void setText(String text);

  void save();

  void initialize();
}

class _CardAdderBloc implements CardAdderBloc {
  _CardAdderBloc({
    @required this.cardAddable,
    @required this.cardCreateLoggable,
    @required this.session,
  })  : assert(cardAddable != null),
        assert(cardCreateLoggable != null),
        assert(session != null);

  final CardAddable cardAddable;

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
      await cardAddable.add(
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

class CardAdderBlocFactory {
  CardAdderBlocFactory({
    @required CardAddable cardAddable,
    @required CardCreateLoggable cardCreateLoggable,
  })  : assert(cardAddable != null),
        assert(cardCreateLoggable != null),
        _cardAddable = cardAddable,
        _cardCreateLoggable = cardCreateLoggable;

  final CardAddable _cardAddable;

  final CardCreateLoggable _cardCreateLoggable;

  CardAdderBloc create({@required AuthenticationSession session}) =>
      _CardAdderBloc(
        session: session,
        cardAddable: _cardAddable,
        cardCreateLoggable: _cardCreateLoggable,
      );
}
