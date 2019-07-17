import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import '../blocs/new_card_edit_bloc.dart';
import './common_interfaces/text_speechable.dart';

export './common_interfaces/text_speechable.dart';

class NewCardEditBlocFactory {
  NewCardEditBlocFactory({@required TextSpeechable textSpeechable})
      : assert(textSpeechable != null),
        _textSpeechable = textSpeechable;

  TextSpeechable _textSpeechable;

  NewCardEditBloc create() => new _NewCardEditBloc(
        textSpeechable: _textSpeechable,
      );
}

class _NewCardEditBloc implements NewCardEditBloc {
  _NewCardEditBloc({TextSpeechable textSpeechable})
      : assert(textSpeechable != null),
        _textSpeechable = textSpeechable;

  final TextSpeechable _textSpeechable;

  BehaviorSubject<String> _text;

  @override
  ValueObservable<String> get text => _text;

  @override
  ValueObservable<bool> get isTextValid => ValueConnectableObservable.seeded(
        _text.map((text) => _isValidText(text)),
        _isValidText(_text.value),
      ).autoConnect();

  BehaviorSubject<Tuple2<String, bool>> _textPreloadState;

  @override
  ValueObservable<bool> get isSpeechSoundLoaded =>
      ValueConnectableObservable.seeded(
        Observable.combineLatest2(
            _text,
            _textPreloadState,
            (text, preloadState) =>
                text == preloadState.item1 && preloadState.item2),
        _textPreloadState.hasValue &&
            _text.value == _textPreloadState.value.item1 &&
            _textPreloadState.value.item2,
      ).autoConnect();

  @override
  setText(String text) => _text.add(text);

  @override
  void speech() {
    assert(isTextValid.value);

    _textSpeechable.speech(text.value);
  }

  @override
  void initialize() {
    _text = BehaviorSubject.seeded("")
      ..debounceTime(const Duration(milliseconds: 1000)).listen((text) async {
        if (_isValidText(text) && !_textPreloadState.isClosed) {
          _textPreloadState.add(Tuple2(text, false));
        }
      });
    _textPreloadState = BehaviorSubject()
      ..listen((preloadState) async {
        if (!preloadState.item2) {
          await _textSpeechable.preload(preloadState.item1);

          _textPreloadState.add(preloadState.withItem2(true));
        }
      });
  }

  @override
  void dispose() {
    _text.close();
    _textPreloadState.close();
  }

  static final _validTextRegExp = RegExp("^[ !?\"&',\\-.0-9A-Za-z]+\$");

  static bool _isValidText(String text) =>
      text.isNotEmpty && _validTextRegExp.hasMatch(text);
}
