import 'dart:io' show File;

mixin SoundFilePlayable {
  Future<void> play(File file);
}
