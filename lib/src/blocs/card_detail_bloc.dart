import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './authenticatable.dart';
import './review_subscribable.dart';
export './review_subscribable.dart' show Card, Review;

abstract class CardDetailBloc {
  Card get card;

  ValueObservable<List<Review>> get reviews;
}

class _CardDetailBloc implements CardDetailBloc {
  _CardDetailBloc({
    @required this.card,
    @required Authenticatable authenticatable,
    @required ReviewSubscribable reviewSubscribable,
  })  : assert(card != null),
        assert(authenticatable != null),
        assert(reviewSubscribable != null),
        _authenticatable = authenticatable,
        _reviewSubscribable = reviewSubscribable;

  @override
  final Card card;

  final Authenticatable _authenticatable;

  final ReviewSubscribable _reviewSubscribable;

  @override
  ValueObservable<List<Review>> get reviews =>
      _reviewSubscribable.subscribeReviewsInCard(
        user: _authenticatable.user.value,
        card: card,
      );
}

class CardDetailBlocFactory {
  CardDetailBlocFactory({
    @required Authenticatable authenticatable,
    @required ReviewSubscribable reviewSubscribable,
  })  : assert(authenticatable != null),
        assert(reviewSubscribable != null),
        _authenticatable = authenticatable,
        _reviewSubscribable = reviewSubscribable;

  final Authenticatable _authenticatable;

  final ReviewSubscribable _reviewSubscribable;

  CardDetailBloc create(Card card) => _CardDetailBloc(
        card: card,
        authenticatable: _authenticatable,
        reviewSubscribable: _reviewSubscribable,
      );
}
