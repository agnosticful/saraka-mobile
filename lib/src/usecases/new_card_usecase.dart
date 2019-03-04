import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class NewCardUsecase {
  NewCardUsecase({
    @required DataPersistentService dataPersistentService,
    @required ExternalFunctionService externalFunctionService,
  })  : assert(dataPersistentService != null),
        _dataPersistentService = dataPersistentService,
        assert(externalFunctionService != null),
        _externalFunctionService = externalFunctionService;

  final DataPersistentService _dataPersistentService;

  final ExternalFunctionService _externalFunctionService;

  NewCard call() => _NewCard(
        dataPersistentService: _dataPersistentService,
        externalFunctionService: _externalFunctionService,
      );
}

class _NewCard extends NewCard {
  _NewCard({
    @required DataPersistentService dataPersistentService,
    @required ExternalFunctionService externalFunctionService,
  })  : assert(dataPersistentService != null),
        _dataPersistentService = dataPersistentService,
        assert(externalFunctionService != null),
        _externalFunctionService = externalFunctionService;

  final DataPersistentService _dataPersistentService;

  final ExternalFunctionService _externalFunctionService;

  final _onChange = StreamController<NewCard>.broadcast();

  _TextSynthesization _textSynthesization;

  String _text = "";

  @override
  String get text => _text;

  @override
  set text(String text) {
    this._text = text;

    final previousTextSynthesization = _textSynthesization;

    if (text.length == 0) {
      _textSynthesization = null;
    } else {
      final textSynthesization = _TextSynthesization(
        text,
        dataPersistentService: _dataPersistentService,
        externalFunctionService: _externalFunctionService,
      );

      textSynthesization.onChange.listen((_) {
        _onChange.add(this);
      });

      _textSynthesization = textSynthesization;
    }

    if (previousTextSynthesization != null) {
      previousTextSynthesization.dispose();
    }

    _onChange.add(this);
  }

  @override
  bool get isReadyToSynthesize =>
      _textSynthesization != null && _textSynthesization.isReadyToPlay;

  @override
  Stream<NewCard> get onChange => _onChange.stream;

  @override
  void synthesize() {
    assert(isReadyToSynthesize);

    _textSynthesization.play();
  }

  @override
  Future<void> save() async {
    print(_text);
  }

  @override
  void dispose() => _onChange.close();
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
