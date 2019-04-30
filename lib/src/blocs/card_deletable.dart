import 'package:meta/meta.dart';
import 'package:saraka/entities.dart' show Card, User;
export 'package:saraka/entities.dart' show Card, User;

mixin CardDeletable {
  Future<void> deleteCard({
    @required User user,
    @required Card card,
  });
}
