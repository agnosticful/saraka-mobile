import 'package:meta/meta.dart';
import '../entities/new_card_text.dart';
import '../entities/user.dart';
export '../entities/new_card_text.dart';
export '../entities/user.dart';

mixin CardAddable {
  Future<void> add({@required User user, @required NewCardText text});
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.text);

  final String text;

  String toString() => 'CardDuplicationException: `$text` is already existing.';
}
