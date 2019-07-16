import 'dart:convert' show base64, utf8;
import 'dart:io' show File;
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:meta/meta.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../blocs/new_card_edit_bloc.dart';

class TextSpeechService implements TextSpeechable {
  TextSpeechService({
    @required AudioPlayer audioPlayer,
    @required CloudFunctions cloudFunctions,
  })  : assert(audioPlayer != null),
        assert(cloudFunctions != null),
        _audioPlayer = audioPlayer,
        _synthesizeFunction =
            cloudFunctions.getHttpsCallable(functionName: 'synthesize');

  final AudioPlayer _audioPlayer;

  final HttpsCallable _synthesizeFunction;

  Future<void> speech(String text) async {
    final file = await _referSpeechFile(text);

    print(file);

    assert(await file.exists());

    await _audioPlayer.play(file.path, isLocal: true);
  }

  Future<void> loadSoundDataInAdvance(String text) async {
    final file = await _referSpeechFile(text);

    if (await file.exists()) {
      return;
    }

    final data = await _synthesize(text);

    await file.writeAsBytes(data);
  }

  Future<File> _referSpeechFile(String text) async {
    final cacheDirectory = await getTemporaryDirectory();
    final path = join(
      cacheDirectory.path,
      sha256.convert(utf8.encode(text)).toString(),
    );

    return File(path);
  }

  Future<List<int>> _synthesize(String text) async {
    HttpsCallableResult result;

    try {
      result = await _synthesizeFunction({
        "text": text,
      });
    } on CloudFunctionsException catch (error) {
      // TODO(axross): throw SynthesizationFailureException

      rethrow;
    }

    print(result);

    return base64.decode(result.data);
  }
}

class SynthesizationFailureException implements Exception {
  SynthesizationFailureException(this.text);

  final String text;

  String toString() =>
      'SynthesizationFailureException: synthesization `$text` has failed.';
}
