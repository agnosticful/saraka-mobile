abstract class TextSynthesization {
  bool get isFetching;

  bool get isStoring;

  bool get isReadyToPlay => isFetching == false && isStoring == false;

  Stream<TextSynthesization> get onChange;

  void play();

  void dispose();
}
