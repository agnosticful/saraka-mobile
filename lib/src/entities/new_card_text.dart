abstract class NewCardText {
  String get text;

  bool get isValid => _validateText(text);

  static final _validTextRegExp = RegExp("^[ !\"&',\\-.0-9A-Za-z]+\$");

  static _validateText(String text) =>
      text.isNotEmpty && _validTextRegExp.hasMatch(text);
}
