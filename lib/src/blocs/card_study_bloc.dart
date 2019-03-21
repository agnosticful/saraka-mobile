import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';

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

  void studiedWell(Card card);

  void studiedVaguely(Card card);

  void undo();
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
        _inQueueCardSubscribable = inQueueCardSubscribable {
    _inQueueCardSubscribable
        .subscribeInQueueCards(
          user: _authenticatable.user.value,
        )
        .first
        .then((cards) {
      _allInQueueCardsAtFirst = cards;
    });

    finishedRatio.where((ratio) => ratio == 1).listen((_) {});
  }

  final Authenticatable _authenticatable;

  final CardStudyable _cardStudyable;

  final CardStudyLoggable _cardStudyLoggable;

  final InQueueCardSubscribable _inQueueCardSubscribable;

  List<Card> _allInQueueCardsAtFirst = [];

  final BehaviorSubject<List<Card>> _studiedCards = BehaviorSubject.seeded([]);

  @override
  Observable<List<Card>> get cardsInQueue => _studiedCards.map(
        (studiedCards) => _allInQueueCardsAtFirst
            .where(
              (card) => !studiedCards.contains(card),
            )
            .toList(),
      );

  @override
  Observable<double> get finishedRatio => _studiedCards.map(
        (studiedCards) => _allInQueueCardsAtFirst.length == 0
            ? 0
            : (studiedCards.length) / _allInQueueCardsAtFirst.length,
      );

  @override
  Observable<bool> get canUndo =>
      _studiedCards.map((studiedCards) => studiedCards.length > 0);

  @override
  Future<void> studiedWell(Card card) async {
    _studiedCards.add(_studiedCards.value.toList()..add(card));

    await _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.good,
      user: _authenticatable.user.value,
    );

    await _cardStudyLoggable.logCardStudy(certainty: StudyCertainty.good);
  }

  @override
  Future<void> studiedVaguely(Card card) async {
    _studiedCards.add(_studiedCards.value.toList()..add(card));

    await _cardStudyable.study(
      card: card,
      certainty: StudyCertainty.vague,
      user: _authenticatable.user.value,
    );

    await _cardStudyLoggable.logCardStudy(certainty: StudyCertainty.vague);
  }

  @override
  void undo() async {
    assert(_studiedCards.value.length >= 1);

    final card = _studiedCards.value.last;

    _studiedCards.add(List.from(_studiedCards.value)..remove(card));

    await _cardStudyable.undoStudy(
      card: card,
      user: _authenticatable.user.value,
    );
  }
}

enum StudyCertainty {
  good,
  vague,
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
  Future<void> logCardStudy({@required StudyCertainty certainty});
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
