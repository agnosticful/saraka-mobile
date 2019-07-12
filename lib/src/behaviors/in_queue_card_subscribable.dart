import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';

abstract class InQueueCardSubscribable {
  Observable<List<Card>> subscribeInQueueCards(
      {@required AuthenticationSession session});
}
