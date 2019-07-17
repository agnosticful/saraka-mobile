abstract class TextSpeechable {
  Future<void> speech(String text);

  Future<bool> isPreloaded(String text);

  Future<void> preload(String text);
}
