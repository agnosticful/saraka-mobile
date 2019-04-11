abstract class ReviewCertainty {
  static const ReviewCertainty good = const _ReviewCertainty('GOOD');

  static const ReviewCertainty vague = const _ReviewCertainty('VAGUE');

  static parse(String value) {
    switch (value) {
      case "GOOD":
        return ReviewCertainty.good;
      case "VAGUE":
        return ReviewCertainty.good;
    }

    throw new ReviewCertaintyParseException(value);
  }
}

class _ReviewCertainty implements ReviewCertainty {
  const _ReviewCertainty(this.value);

  final String value;

  @override
  String toString() => value;
}

class ReviewCertaintyParseException implements Exception {
  ReviewCertaintyParseException(this.value);

  final String value;

  String toString() =>
      'ReviewCertaintyParseException: `$value` cannot be parsed as ReviewCertain.';
}
