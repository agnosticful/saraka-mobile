import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';

abstract class CardSubscribable {
  ValueObservable<List<Card>> subscribeCards({
    @required AuthenticationSession session,
  });
}
