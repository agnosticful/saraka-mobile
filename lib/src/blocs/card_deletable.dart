import 'package:meta/meta.dart';
import '../entities/card.dart';
import '../entities/user.dart';
export '../entities/card.dart';
export '../entities/user.dart';

mixin CardDeletable {
  Future<void> deleteCard({
    @required User user,
    @required Card card,
  });
}
