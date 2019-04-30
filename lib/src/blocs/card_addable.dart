import 'package:meta/meta.dart';
import 'package:saraka/entities.dart' show NewCardText, User;
export 'package:saraka/entities.dart' show NewCardText, User;

mixin CardAddable {
  Future<void> add({@required User user, @required NewCardText text});
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.text);

  final String text;

  String toString() => 'CardDuplicationException: `$text` is already existing.';
}
