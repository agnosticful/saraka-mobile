import 'dart:io' show File;
import 'package:audioplayers/audioplayers.dart';
import '../blocs/sound_file_playable.dart';

class SoundPlayer implements SoundFilePlayable {
  final _audioPlayer = AudioPlayer();

  @override
  Future<void> play(File file) async {
    assert(await file.exists());

    await _audioPlayer.play(file.path);
  }
}
