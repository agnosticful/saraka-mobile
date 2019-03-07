abstract class TextSynthesization {
  bool get isReadyToPlay;

  Stream<TextSynthesization> get onChange;

  Future<void> get onReadyToPlay;

  void play();

  void dispose();
}
