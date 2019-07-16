import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class NewCardEditBloc {
  ValueObservable<String> get text;

  ValueObservable<bool> get isTextValid;

  ValueObservable<bool> get isSpeechSoundCached;

  setText(String text);

  void speech();

  void initialize();

  void dispose();
}

class NewCardEditBlocFactory {
  NewCardEditBlocFactory({@required TextSpeechable textSpeechable})
      : assert(textSpeechable != null),
        _textSpeechable = textSpeechable;

  TextSpeechable _textSpeechable;

  NewCardEditBloc create() => new _NewCardEditBloc(
        textSpeechable: _textSpeechable,
      );
}

abstract class TextSpeechable {
  Future<void> speech(String text);

  Future<void> loadSoundDataInAdvance(String text);
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

  BehaviorSubject<bool> _hasEverSpeechSoundCached;

  BehaviorSubject<int> _speechSoundCachingCounter;

  @override
  ValueObservable<bool> get isSpeechSoundCached =>
      ValueConnectableObservable.seeded(
        Observable.combineLatest2(
          _hasEverSpeechSoundCached,
          _speechSoundCachingCounter.map((value) => value == 0),
          (a, b) => a && b,
        ),
        _hasEverSpeechSoundCached.value &&
            _speechSoundCachingCounter.value == 0,
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
        if (_hasEverSpeechSoundCached.isClosed ||
            _speechSoundCachingCounter.isClosed) {
          return;
        }

        if (_isValidText(text)) {
          _speechSoundCachingCounter.add(_speechSoundCachingCounter.value + 1);

          await _textSpeechable.loadSoundDataInAdvance(text);

          _hasEverSpeechSoundCached.add(true);
          _speechSoundCachingCounter.add(_speechSoundCachingCounter.value - 1);
        }
      });
    _hasEverSpeechSoundCached = BehaviorSubject.seeded(false);
    _speechSoundCachingCounter = BehaviorSubject.seeded(0);
  }

  @override
  void dispose() {
    _text.close();
    _hasEverSpeechSoundCached.close();
    _speechSoundCachingCounter.close();
  }

  static final _validTextRegExp = RegExp("^[ !?\"&',\\-.0-9A-Za-z]+\$");

  static bool _isValidText(String text) =>
      text.isNotEmpty && _validTextRegExp.hasMatch(text);
}
