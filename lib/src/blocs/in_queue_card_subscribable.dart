import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';
import '../entities/user.dart';
export '../entities/card.dart';
export '../entities/user.dart';

mixin InQueueCardSubscribable {
  Observable<List<Card>> subscribeInQueueCards({@required User user});
}
