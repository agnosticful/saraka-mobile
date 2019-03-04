import 'dart:async';

abstract class NewCard {
  String text;

  bool get isTextValid => text.isNotEmpty && _validTextRegExp.hasMatch(text);

  bool get isReadyToSynthesize;

  bool get isReadyToSave => text.length > 0 && isReadyToSynthesize;

  Stream<NewCard> get onChange;

  void synthesize();

  Future<void> save();

  void dispose();

  static final _validTextRegExp = RegExp("^[ !\"&',\\-.0-9A-Za-z]+\$");
}

class NewCardDuplicationException {}
