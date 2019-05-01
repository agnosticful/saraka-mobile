import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';
export '../entities/authentication_session.dart';
export '../entities/card.dart';

mixin CardDeletable {
  Future<void> deleteCard({
    @required Card card,
    @required AuthenticationSession session,
  });
}
