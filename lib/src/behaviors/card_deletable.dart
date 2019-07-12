import 'package:meta/meta.dart';
import 'package:saraka/entities.dart';

abstract class CardDeletable {
  Future<void> deleteCard({
    @required Card card,
    @required AuthenticationSession session,
  });
}
