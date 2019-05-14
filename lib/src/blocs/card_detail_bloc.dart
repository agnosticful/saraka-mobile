import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../behaviors/review_subscribable.dart';
import '../entities/authentication_session.dart';
import '../entities/card.dart';
import '../entities/review.dart';

abstract class CardDetailBloc {
  Card get card;

  ValueObservable<List<Review>> get reviews;
}

class _CardDetailBloc implements CardDetailBloc {
  _CardDetailBloc({
    @required this.card,
    @required this.reviewSubscribable,
    @required this.session,
  })  : assert(card != null),
        assert(session != null),
        assert(reviewSubscribable != null);

  @override
  final Card card;

  final ReviewSubscribable reviewSubscribable;

  final AuthenticationSession session;

  @override
  ValueObservable<List<Review>> get reviews =>
      reviewSubscribable.subscribeReviewsInCard(
        session: session,
        card: card,
      );
}

class CardDetailBlocFactory {
  CardDetailBlocFactory({
    @required ReviewSubscribable reviewSubscribable,
  })  : assert(reviewSubscribable != null),
        _reviewSubscribable = reviewSubscribable;

  final ReviewSubscribable _reviewSubscribable;

  CardDetailBloc create({
    @required Card card,
    @required AuthenticationSession session,
  }) =>
      _CardDetailBloc(
        card: card,
        reviewSubscribable: _reviewSubscribable,
        session: session,
      );
}
