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
  ValueObservable<bool> isInitialized;

  List<Card> get cards;

  ValueObservable<int> get finishedCardLength;

  ValueObservable<int> get remainingCardLength =>
      ValueConnectableObservable.seeded(
        finishedCardLength.map((length) => cards.length - length),
        cards.length - finishedCardLength.value,
      ).autoConnect();

  ValueObservable<double> get finishedCardRatio =>
      ValueConnectableObservable.seeded(
        finishedCardLength.map(
            (length) => length == 0 ? 0.0 : length.toDouble() / cards.length),
        finishedCardLength.value == 0
            ? 0.0
            : finishedCardLength.value.toDouble() / cards.length,
      ).autoConnect();

  ValueObservable<bool> get isFinished => ValueConnectableObservable.seeded(
        finishedCardLength.map((length) => length == cards.length),
        finishedCardLength.value == cards.length,
      ).autoConnect();

  ValueObservable<bool> get canUndo => ValueConnectableObservable.seeded(
        finishedCardLength.map((length) => length >= 1),
        finishedCardLength.value >= 1,
      ).autoConnect();

  void reviewedWell(Card card);

  void reviewedVaguely(Card card);

  void undo();

  void initialize();

  void dispose();
}

class _CardReviewBloc extends CardReviewBloc {
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

    cardReviewLoggable.logCardReview(
      certainty: ReviewCertainty.good,
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

    cardReviewLoggable.logCardReview(
      certainty: ReviewCertainty.vague,
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

    cardReviewLoggable.logCardReviewUndo();
  }

  @override
  void initialize() async {
    _cards = await inQueueCardSubscribable
        .subscribeInQueueCards(session: session)
        .first;

    cardReviewLoggable.logReviewStart(cardLength: cards.length);

    _isInitialized.add(true);
  }

  @override
  Future<void> dispose() async {
    cardReviewLoggable.logReviewEnd(
      cardLength: cards.length,
      reviewedCardLength: _finishedCards.value.length,
    );

    _isInitialized.close();
    _finishedCards.close();
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
