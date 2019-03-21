abstract class StudyCertainty {
  static const StudyCertainty good = const _StudyCertainty('GOOD');

  static const StudyCertainty vague = const _StudyCertainty('VAGUE');

  static parse(String value) {
    switch (value) {
      case "GOOD":
        return StudyCertainty.good;
      case "VAGUE":
        return StudyCertainty.good;
    }

    throw new StudyCertaintyParseException(value);
  }
}

class _StudyCertainty implements StudyCertainty {
  const _StudyCertainty(this.value);

  final String value;

  @override
  String toString() => value;
}

class StudyCertaintyParseException implements Exception {
  StudyCertaintyParseException(this.value);

  final String value;

  String toString() =>
      'StudyCertaintyParseException: `$value` cannot be parsed as StudyCertain.';
}
