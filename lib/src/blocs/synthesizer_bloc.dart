import 'dart:io' show File;
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class SynthesizerBlocFactory {
  SynthesizerBlocFactory({
    @required SoundFilePlayable soundFilePlayable,
    @required Synthesizable synthesizable,
    @required SynthesizedSoundFileReferable synthesizedSoundFileReferable,
  })  : assert(soundFilePlayable != null),
        assert(synthesizedSoundFileReferable != null),
        assert(synthesizable != null),
        _soundFilePlayable = soundFilePlayable,
        _synthesizable = synthesizable,
        _synthesizedSoundFileReferable = synthesizedSoundFileReferable;

  final SoundFilePlayable _soundFilePlayable;

  final Synthesizable _synthesizable;

  final SynthesizedSoundFileReferable _synthesizedSoundFileReferable;

  SynthesizerBloc create() => _SynthesizerBloc(
        soundFilePlayable: _soundFilePlayable,
        synthesizable: _synthesizable,
        synthesizedSoundFileReferable: _synthesizedSoundFileReferable,
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
  })  : assert(soundFilePlayable != null),
        assert(synthesizable != null),
        assert(synthesizedSoundFileReferable != null),
        _soundFilePlayable = soundFilePlayable,
        _synthesizable = synthesizable,
        _synthesizedSoundFileReferable = synthesizedSoundFileReferable;

  final SoundFilePlayable _soundFilePlayable;

  final Synthesizable _synthesizable;

  final SynthesizedSoundFileReferable _synthesizedSoundFileReferable;

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
