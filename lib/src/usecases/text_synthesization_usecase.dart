import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class TextSynthesizationUsecase {
  TextSynthesizationUsecase({
    @required DataPersistentService dataPersistentService,
    @required ExternalFunctionService externalFunctionService,
  })  : assert(dataPersistentService != null),
        assert(externalFunctionService != null),
        _dataPersistentService = dataPersistentService,
        _externalFunctionService = externalFunctionService;

  final DataPersistentService _dataPersistentService;

  final ExternalFunctionService _externalFunctionService;

  Future<TextSynthesization> call(String text) async => _TextSynthesization(
        text,
        dataPersistentService: _dataPersistentService,
        externalFunctionService: _externalFunctionService,
      );
}

class _TextSynthesization extends TextSynthesization {
  _TextSynthesization(
    String text, {
    @required DataPersistentService dataPersistentService,
    @required ExternalFunctionService externalFunctionService,
  })  : assert(dataPersistentService != null),
        assert(externalFunctionService != null) {
    dataPersistentService.getCachedSynthesizationFile(text).then((file) async {
      if (!await file.exists()) {
        _isFetching = true;
        _onChange.add(this);

        final audio = await externalFunctionService.synthesize(text);

        await file.writeAsBytes(audio);

        _isFetching = false;
        _onChange.add(this);
      }

      _isCached = true;
      this._file = file;
      _onChange.add(this);
    });
  }

  final _audioPlayer = AudioPlayer();

  final _onChange = StreamController<TextSynthesization>.broadcast();

  bool _isCached = false;

  bool _isFetching = false;

  @override
  bool get isReadyToPlay => _isCached && !_isFetching;

  @override
  Future<void> get onReadyToPlay => isReadyToPlay
      ? Future.value(null)
      : _onChange.stream.firstWhere((_) => isReadyToPlay == true);

  @override
  Stream<TextSynthesization> get onChange => _onChange.stream;

  File _file;

  @override
  void play() {
    assert(isReadyToPlay);

    _audioPlayer.play(_file.path);
  }

  @override
  void dispose() => _onChange.close();
}
