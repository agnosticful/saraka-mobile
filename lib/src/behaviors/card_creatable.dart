import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

abstract class CardCreatable {
  Future<void> add({
    @required AuthenticationSession session,
    @required NewCardText text,
  });
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.text);

  final String text;

  String toString() => 'CardDuplicationException: `$text` is already existing.';
}
