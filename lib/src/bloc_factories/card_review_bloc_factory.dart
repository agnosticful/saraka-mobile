import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../blocs/card_review_bloc.dart';
import '../entities/authentication_session.dart';
import '../entities/review_certainty.dart';

export '../entities/authentication_session.dart';
export '../entities/card.dart';
export '../entities/review_certainty.dart';

class CardReviewBlocFactory {
  CardReviewBlocFactory({
    @required CardReviewable cardReviewable,
    @required InQueueCardListable inQueueCardListable,
  })  : assert(cardReviewable != null),
        assert(inQueueCardListable != null),
        _cardReviewable = cardReviewable,
        _inQueueCardListable = inQueueCardListable;

  final CardReviewable _cardReviewable;

  final InQueueCardListable _inQueueCardListable;

  CardReviewBloc create({@required AuthenticationSession session}) =>
      _CardReviewBloc(
        session: session,
        cardReviewable: _cardReviewable,
        inQueueCardListable: _inQueueCardListable,
      );
}

abstract class CardReviewable {
  /// @throws ReviewDuplicationException
  Future<void> review({
    @required AuthenticationSession session,
    @required Card card,
    @required ReviewCertainty certainty,
  });

  /// @throws ReviewOverundoException
  Future<void> undoReview({
    @required AuthenticationSession session,
    @required Card card,
  });
}

class ReviewDuplicationException implements Exception {
  ReviewDuplicationException(this.card);

  final Card card;

  String toString() =>
      'ReviewDuplicationException: `${card.id}` has been just reviewed.';
}

class ReviewOverundoException implements Exception {
  ReviewOverundoException(this.card);

  final Card card;

  String toString() =>
      'ReviewOverundoException: `${card.id}` doesn\'t have review to undo.';
}

abstract class InQueueCardListable {
  Observable<List<Card>> subscribeInQueueCards({
    @required AuthenticationSession session,
  });
}

class _CardReviewBloc extends CardReviewBloc {
  _CardReviewBloc({
    @required this.cardReviewable,
    @required this.inQueueCardListable,
    @required this.session,
  })  : assert(cardReviewable != null),
        assert(inQueueCardListable != null),
        assert(session != null);

  final CardReviewable cardReviewable;

  final InQueueCardListable inQueueCardListable;

  final AuthenticationSession session;

  final _isInitialized = BehaviorSubject.seeded(false);

  @override
  ValueObservable<bool> get isInitialized => _isInitialized;

  List<Card> _cards = [];

  @override
  List<Card> get cards => _cards;

  final _finishedCards = BehaviorSubject<List<Card>>.seeded([]);

  @override
  ValueObservable<int> get finishedCardLength =>
      ValueConnectableObservable.seeded(
              _finishedCards.map((cards) => cards.length),
              _finishedCards.value.length)
          .autoConnect();

  @override
  Future<void> reviewedWell(Card card) async {
    _finishedCards.add(_finishedCards.value..add(card));

    cardReviewable.review(
      card: card,
      certainty: ReviewCertainty.good,
      session: session,
    );
  }

  @override
  Future<void> reviewedVaguely(Card card) async {
    _finishedCards.add(_finishedCards.value..add(card));

    cardReviewable.review(
      card: card,
      certainty: ReviewCertainty.vague,
      session: session,
    );
  }

  @override
  void undo() async {
    assert(canUndo.value);

    final card = _finishedCards.value.last;

    _finishedCards.add(_finishedCards.value..remove(card));

    cardReviewable.undoReview(
      card: card,
      session: session,
    );
  }

  @override
  void initialize() async {
    _cards =
        await inQueueCardListable.subscribeInQueueCards(session: session).first;

    _isInitialized.add(true);
  }

  @override
  Future<void> dispose() async {
    _isInitialized.close();
    _finishedCards.close();
  }
}
