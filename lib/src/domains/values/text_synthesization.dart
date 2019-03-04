abstract class TextSynthesization {
  bool get isReadyToPlay;

  Stream<TextSynthesization> get onChange;

  void play();

  void dispose();
}
