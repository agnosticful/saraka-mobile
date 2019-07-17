import 'package:rxdart/rxdart.dart';

abstract class NewCardEditBloc {
  ValueObservable<String> get text;

  ValueObservable<bool> get isTextValid;

  ValueObservable<bool> get isSpeechSoundLoaded;

  setText(String text);

  void speech();

  void initialize();

  void dispose();
}
