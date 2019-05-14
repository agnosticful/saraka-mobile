import 'dart:io' show File;

abstract class SynthesizedSoundFileReferable {
  Future<File> referSynthesizedSoundFile(String text);
}
