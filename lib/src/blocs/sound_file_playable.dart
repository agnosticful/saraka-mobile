import 'dart:io' show File;

abstract class SoundFilePlayable {
  Future<void> play(File file);
}
