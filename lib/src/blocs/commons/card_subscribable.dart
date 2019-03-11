import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';

export 'package:saraka/entities.dart' show Card, User;

mixin CardSubscribable {
  Observable<Iterable<Card>> subscribeCards({@required User user});
}
