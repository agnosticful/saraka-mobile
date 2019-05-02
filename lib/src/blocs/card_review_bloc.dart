import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';
import '../entities/review_certainty.dart';
import './card_reviewable.dart';
import './card_review_loggable.dart';
import './in_queue_card_subscribable.dart';
export '../entities/card.dart';
export '../entities/review_certainty.dart';

abstract class CardReviewBloc {
  Observable<List<Card>> get cardsInQueue;

  Observable<double> get finishedRatio;

  Observable<bool> get canUndo;

  void initialize();

  void reviewedWell(Card card);

  void reviewedVaguely(Card card);

  void undo();

  void dispose();
}

class _CardReviewBloc implements CardReviewBloc {
  _CardReviewBloc({
    @required this.cardReviewable,
    @required this.cardReviewLoggable,
    @required this.inQueueCardSubscribable,
    @required this.session,
  })  : assert(cardReviewable != null),
        assert(cardReviewLoggable != null),
        assert(inQueueCardSubscribable != null),
        assert(session != null);

  final CardReviewable cardReviewable;

  final CardReviewLoggable cardReviewLoggable;

  final InQueueCardSubscribable inQueueCardSubscribable;

  final AuthenticationSession session;

  final BehaviorSubject<List<Card>> _allInQueueCards =
      BehaviorSubject.seeded([]);

  final BehaviorSubject<List<Card>> _reviewedCards = BehaviorSubject.seeded([]);

  @override
  Observable<List<Card>> get cardsInQueue => Observable.combineLatest2(
        _allInQueueCards,
        _reviewedCards,
        (allCards, reviewedCards) =>
            allCards.where((card) => !reviewedCards.contains(card)).toList(),
      );

  @override
  Observable<double> get finishedRatio => Observable.combineLatest2(
        _allInQueueCards,
        _reviewedCards,
        (allCards, reviewedCards) {
          final numberOfAllCards = allCards.length;

          return numberOfAllCards == 0
              ? 0
              : reviewedCards.length / numberOfAllCards;
        },
      );

  @override
  Observable<bool> get canUndo =>
      _reviewedCards.map((reviewedCards) => reviewedCards.length > 0);

  @override
  void initialize() async {
    final cards = await inQueueCardSubscribable
        .subscribeInQueueCards(session: session)
        .first;

    cardReviewLoggable.logReviewStart(cardLength: cards.length);

    _allInQueueCards.add(cards);

    finishedRatio.listen((ratio) {
      if (ratio == 1) {
        cardReviewLoggable.logReviewEnd(
          cardLength: cards.length,
          reviewedCardLength: _reviewedCards.value.length,
        );
      }
    });
  }

  @override
  Future<void> reviewedWell(Card card) async {
    _reviewedCards.add(List.from(_reviewedCards.value)..add(card));

    cardReviewable.review(
      card: card,
      certainty: ReviewCertainty.good,
      session: session,
    );

    cardReviewLoggable.logCardReview(
      certainty: ReviewCertainty.good,
    );
  }

  @override
  Future<void> reviewedVaguely(Card card) async {
    _reviewedCards.add(List.from(_reviewedCards.value)..add(card));

    cardReviewable.review(
      card: card,
      certainty: ReviewCertainty.vague,
      session: session,
    );

    cardReviewLoggable.logCardReview(
      certainty: ReviewCertainty.vague,
    );
  }

  @override
  void undo() async {
    assert(_reviewedCards.value.length >= 1);

    final lastCard = _reviewedCards.value.last;

    _reviewedCards.add(List.from(_reviewedCards.value)..remove(lastCard));

    cardReviewable.undoReview(
      card: lastCard,
      session: session,
    );

    cardReviewLoggable.logCardReviewUndo();
  }

  @override
  Future<void> dispose() async {
    cardReviewLoggable.logReviewEnd(
      cardLength: _allInQueueCards.value.length,
      reviewedCardLength: _reviewedCards.value.length,
    );
  }
}

class CardReviewBlocFactory {
  CardReviewBlocFactory({
    @required CardReviewable cardReviewable,
    @required CardReviewLoggable cardReviewLoggable,
    @required InQueueCardSubscribable inQueueCardSubscribable,
  })  : assert(cardReviewable != null),
        assert(cardReviewLoggable != null),
        assert(inQueueCardSubscribable != null),
        _cardReviewable = cardReviewable,
        _cardReviewLoggable = cardReviewLoggable,
        _inQueueCardSubscribable = inQueueCardSubscribable;

  final CardReviewable _cardReviewable;

  final CardReviewLoggable _cardReviewLoggable;

  final InQueueCardSubscribable _inQueueCardSubscribable;

  CardReviewBloc create({@required AuthenticationSession session}) =>
      _CardReviewBloc(
        session: session,
        cardReviewable: _cardReviewable,
        cardReviewLoggable: _cardReviewLoggable,
        inQueueCardSubscribable: _inQueueCardSubscribable,
      );
}
