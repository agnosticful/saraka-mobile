abstract class LearningCertainty {
  const LearningCertainty(this._value);

  factory LearningCertainty.parse(String string) {
    switch (string) {
      case "GOOD":
        return LearningCertainty.good;
      case "VAGUE":
        return LearningCertainty.vague;
    }

    throw new LearningCertaintyParseException(string);
  }

  final String _value;

  String toString() => _value;

  static const good = _LearningCertainty("GOOD");

  static const vague = _LearningCertainty("VAGUE");
}

class _LearningCertainty extends LearningCertainty {
  const _LearningCertainty(String value) : super(value);
}

class LearningCertaintyParseException implements Exception {
  const LearningCertaintyParseException(this.value) : assert(value != null);

  final String value;

  String get message =>
      '$report: "$value" cannot be parsed to a LearningCertainty.';

  static final report = 'LearningCertaintyParseException';
}
