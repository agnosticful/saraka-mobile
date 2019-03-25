import 'dart:io' show File;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SynthesizerBlocFactory {
  SynthesizerBlocFactory({
    @required SoundFilePlayable soundFilePlayable,
    @required Synthesizable synthesizable,
    @required SynthesizedSoundFileReferable synthesizedSoundFileReferable,
    @required SynthesizeLoggable synthesizeLoggable,
  })  : assert(soundFilePlayable != null),
        assert(synthesizedSoundFileReferable != null),
        assert(synthesizable != null),
        assert(synthesizeLoggable != null),
        _soundFilePlayable = soundFilePlayable,
        _synthesizable = synthesizable,
        _synthesizedSoundFileReferable = synthesizedSoundFileReferable,
        _synthesizeLoggable = synthesizeLoggable;

  final SoundFilePlayable _soundFilePlayable;

  final Synthesizable _synthesizable;

  final SynthesizedSoundFileReferable _synthesizedSoundFileReferable;

  final SynthesizeLoggable _synthesizeLoggable;

  SynthesizerBloc create() => _SynthesizerBloc(
        soundFilePlayable: _soundFilePlayable,
        synthesizable: _synthesizable,
        synthesizedSoundFileReferable: _synthesizedSoundFileReferable,
        synthesizeLoggable: _synthesizeLoggable,
      );
}

abstract class SynthesizerBloc {
  Observable<bool> get isCaching;

  void cacheInAdvance(String text);

  void play(String text);
}

class _SynthesizerBloc implements SynthesizerBloc {
  _SynthesizerBloc({
    @required SoundFilePlayable soundFilePlayable,
    @required Synthesizable synthesizable,
    @required SynthesizedSoundFileReferable synthesizedSoundFileReferable,
    @required SynthesizeLoggable synthesizeLoggable,
  })  : assert(soundFilePlayable != null),
        assert(synthesizable != null),
        assert(synthesizedSoundFileReferable != null),
        assert(synthesizeLoggable != null),
        _soundFilePlayable = soundFilePlayable,
        _synthesizable = synthesizable,
        _synthesizedSoundFileReferable = synthesizedSoundFileReferable,
        _synthesizeLoggable = synthesizeLoggable;

  final SoundFilePlayable _soundFilePlayable;

  final Synthesizable _synthesizable;

  final SynthesizedSoundFileReferable _synthesizedSoundFileReferable;

  final SynthesizeLoggable _synthesizeLoggable;

  final _isCaching = PublishSubject();

  @override
  Observable<bool> get isCaching => _isCaching
      .scan((accumulated, value, _) => accumulated + value, 0)
      .map((value) => value > 0);

  @override
  Future<void> cacheInAdvance(String text) => _cache(text);

  @override
  void play(String text) async {
    final file = await _cache(text);

    _soundFilePlayable.play(file);
  }

  Future<File> _cache(String text) async {
    final file =
        await _synthesizedSoundFileReferable.referSynthesizedSoundFile(text);

    if (!await file.exists()) {
      _isCaching.add(1);

      final sound = await _synthesizable.synthesize(text);

      _synthesizeLoggable.logSynthesize(text: text);

      await file.writeAsBytes(sound);

      _isCaching.add(-1);
    }

    return file;
  }
}

mixin SoundFilePlayable {
  Future<void> play(File file);
}

mixin SynthesizedSoundFileReferable {
  Future<File> referSynthesizedSoundFile(String text);
}

mixin Synthesizable {
  Future<List<int>> synthesize(String text);
}

mixin SynthesizeLoggable {
  Future<void> logSynthesize({@required String text});
}
