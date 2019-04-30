import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart' show Card, User;
export 'package:saraka/entities.dart' show Card, User;

mixin InQueueCardSubscribable {
  Observable<List<Card>> subscribeInQueueCards({@required User user});
}
