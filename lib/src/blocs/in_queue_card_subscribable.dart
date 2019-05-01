import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';
export '../entities/authentication_session.dart';
export '../entities/card.dart';

abstract class InQueueCardSubscribable {
  Observable<List<Card>> subscribeInQueueCards(
      {@required AuthenticationSession session});
}
