abstract class CardCreateBloc {
  Future<void> create(String text);

  void initialize();

  void dispose();
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.text);

  final String text;

  String toString() => 'CardDuplicationException: `$text` already exists.';
}
