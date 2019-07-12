import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';

abstract class UpcomingCardListable {
  ValueObservable<List<Card>> subscribeUpcomingCards({
    @required AuthenticationSession session,
  });
}
