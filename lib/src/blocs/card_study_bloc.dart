import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';

export 'package:saraka/entities.dart' show StudyCertainty;

class CardStudyBlocFactory {
  CardStudyBlocFactory({
    @required Authenticatable authenticatable,
    @required CardStudyable cardStudyable,
    @required CardStudyLoggable cardStudyLoggable,
    @required InQueueCardSubscribable inQueueCardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardStudyable != null),
        assert(inQueueCardSubscribable != null),
        _authenticatable = authenticatable,
        _cardStudyable = cardStudyable,
        _cardStudyLoggable = cardStudyLoggable,
        _inQueueCardSubscribable = inQueueCardSubscribable;

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final CardStudyLoggable _cardStudyLoggable;

  final InQueueCardSubscribable _inQueueCardSubscribable;

  CardStudyBloc create() => _CardStudyBloc(
        authenticatable: _authenticatable,
        cardStudyable: _cardStudyable,
        cardStudyLoggable: _cardStudyLoggable,
        inQueueCardSubscribable: _inQueueCardSubscribable,
      );
}

abstract class CardStudyBloc {
  Observable<List<Card>> get cardsInQueue;

  Observable<double> get finishedRatio;

  Observable<bool> get canUndo;

  void initialize();

  void studiedWell(Card card);

  void studiedVaguely(Card card);

  void undo();

  void dispose();
}

class _CardStudyBloc implements CardStudyBloc {
  _CardStudyBloc({
    @required Authenticatable authenticatable,
    @required CardStudyable cardStudyable,
    @required CardStudyLoggable cardStudyLoggable,
    @required InQueueCardSubscribable inQueueCardSubscribable,
  })  : assert(authenticatable != null),
        assert(cardStudyable != null),
        assert(inQueueCardSubscribable != null),
        _authenticatable = authenticatable,
        _cardStudyable = cardStudyable,
        _cardStudyLoggable = cardStudyLoggable,
        _inQueueCardSubscribable = inQueueCardSubscribable;

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final CardStudyLoggable _cardStudyLoggable;

  final InQueueCardSubscribable _inQueueCardSubscribable;

  final BehaviorSubject<List<Card>> _allInQueueCards =
      BehaviorSubject.seeded([]);

  final BehaviorSubject<List<Card>> _studiedCards = BehaviorSubject.seeded([]);

  @override
  Observable<List<Card>> get cardsInQueue => Observable.combineLatest2(
        _allInQueueCards,
        _studiedCards,
        (allCards, studiedCards) =>
            allCards.where((card) => !studiedCards.contains(card)).toList(),
      );

  @override
  Observable<double> get finishedRatio => Observable.combineLatest2(
        _allInQueueCards,
        _studiedCards,
        (allCards, studiedCards) {
          final numberOfAllCards = allCards.length;

          return numberOfAllCards == 0
              ? 0
              : studiedCards.length / numberOfAllCards;
        },
      );

  @override
  Observable<bool> get canUndo =>
      _studiedCards.map((studiedCards) => studiedCards.length > 0);

  @override
  void initialize() async {
    final cards = await _inQueueCardSubscribable
        .subscribeInQueueCards(user: _authenticatable.user.value)
        .first;

    _cardStudyLoggable.logStudyStart(cardLength: cards.length);

    _allInQueueCards.add(cards);

    finishedRatio.listen((ratio) {
      if (ratio == 1) {
        _cardStudyLoggable.logStudyEnd(
          cardLength: cards.length,
          studiedCardLength: _studiedCards.value.length,
        );
      }
    });
  }

  @override
  Future<void> studiedWell(Card card) async {
    _studiedCards.add(List.from(_studiedCards.value)..add(card));

    _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.good,
      user: _authenticatable.user.value,
    );

    _cardStudyLoggable.logCardStudy(
      certainty: StudyCertainty.good,
    );
  }

  @override
  Future<void> studiedVaguely(Card card) async {
    _studiedCards.add(List.from(_studiedCards.value)..add(card));

    _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.vague,
      user: _authenticatable.user.value,
    );

    _cardStudyLoggable.logCardStudy(
      certainty: StudyCertainty.vague,
    );
  }

  @override
  void undo() async {
    assert(_studiedCards.value.length >= 1);

    final lastCard = _studiedCards.value.last;

    _studiedCards.add(List.from(_studiedCards.value)..remove(lastCard));

    _cardStudyable.undoStudy(
      card: lastCard,
      user: _authenticatable.user.value,
    );

    _cardStudyLoggable.logCardStudyUndo();
  }

  @override
  Future<void> dispose() async {
    _cardStudyLoggable.logStudyEnd(
      cardLength: _allInQueueCards.value.length,
      studiedCardLength: _studiedCards.value.length,
    );
  }
}

mixin CardStudyable {
  Future<void> study({
    @required Card card,
    @required StudyCertainty certainty,
    @required User user,
  });

  Future<void> undoStudy({
    @required Card card,
    @required User user,
  });
}

mixin InQueueCardSubscribable {
  Observable<List<Card>> subscribeInQueueCards({@required User user});
}

mixin CardStudyLoggable {
  Future<void> logStudyStart({@required int cardLength});

  Future<void> logStudyEnd({
    @required int cardLength,
    @required int studiedCardLength,
  });

  Future<void> logCardStudy({@required StudyCertainty certainty});

  Future<void> logCardStudyUndo();
}

class StudyDuplicationException implements Exception {
  StudyDuplicationException(this.card);

  final Card card;

  String toString() =>
      'StudyDuplicationException: `${card.id}` has been just studied.';
}

class StudyOverundoException implements Exception {
  StudyOverundoException(this.card);

  final Card card;

  String toString() =>
      'StudyOverundoException: `${card.id}` doesn\'t have study to undo.';
}
