import 'dart:async';

abstract class NewCard {
  String text;

  bool get isTextValid;

  bool get isReadyToSynthesize;

  bool get isReadyToSave => text.length > 0 && isReadyToSynthesize;

  Stream<NewCard> get onChange;

  void synthesize();

  Future<void> save();

  void dispose();
}
