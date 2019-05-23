import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';

abstract class CardDeletable {
  Future<void> deleteCard({
    @required Card card,
    @required AuthenticationSession session,
  });
}
