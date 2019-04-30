import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import '../entities/card.dart';
import './authenticatable.dart';
import './card_subscribable.dart';
import './introduction_finish_loggable.dart';
import './introduction_finishable.dart';
import './introduction_page_change_loggable.dart';
export '../entities/card.dart';

abstract class IntroductionBloc {
  ValueObservable<List<Card>> get firstCards;

  ValueObservable<bool> get isEnoughCardsAdded;

  BehaviorSubject<bool> get hasAlreadyOpenedNewCardDialogAutomatically;

  Future<void> logPageChange({@required String pageName});

  Future<void> finishIntroduction();
}

class _IntroductionBloc implements IntroductionBloc {
  _IntroductionBloc({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
    @required IntroductionFinishLoggable introductionFinishLoggable,
    @required IntroductionFinishable introductionFinishable,
    @required IntroductionPageChangeLoggable introductionPageChangeLoggable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        assert(introductionFinishLoggable != null),
        assert(introductionFinishable != null),
        assert(introductionPageChangeLoggable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable,
        _introductionFinishLoggable = introductionFinishLoggable,
        _introductionFinishable = introductionFinishable,
        _introductionPageChangeLoggable = introductionPageChangeLoggable {
    final subscription = _cardSubscribable
        .subscribeCards(user: _authenticatable.user.value)
        .listen((cards) {
      firstCards.add(cards.take(necessaryFirstCardLength).toList());
      isEnoughCardsAdded.add(cards.length >= necessaryFirstCardLength);
    });

    firstCards.onCancel =
        () => !firstCards.hasListener ?? subscription.cancel();

    isEnoughCardsAdded.onCancel =
        () => !isEnoughCardsAdded.hasListener ?? subscription.cancel();
  }

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  final IntroductionFinishLoggable _introductionFinishLoggable;

  final IntroductionFinishable _introductionFinishable;

  final IntroductionPageChangeLoggable _introductionPageChangeLoggable;

  @override
  final BehaviorSubject<List<Card>> firstCards = BehaviorSubject();

  @override
  final BehaviorSubject<bool> isEnoughCardsAdded = BehaviorSubject();

  @override
  final hasAlreadyOpenedNewCardDialogAutomatically =
      BehaviorSubject.seeded(false);

  @override
  Future<void> logPageChange({
    @required String pageName,
  }) =>
      _introductionPageChangeLoggable.logIntroductionPageChange(
          pageName: pageName);

  @override
  Future<void> finishIntroduction() => Future.wait([
        _introductionFinishable.finishIntroduction(
            user: _authenticatable.user.value),
        _introductionFinishLoggable.logIntroductionFinish(),
      ]);
}

class IntroductionBlocFactory {
  IntroductionBlocFactory({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
    @required IntroductionFinishLoggable introductionFinishLoggable,
    @required IntroductionFinishable introductionFinishable,
    @required IntroductionPageChangeLoggable introductionPageChangeLoggable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        assert(introductionFinishLoggable != null),
        assert(introductionFinishable != null),
        assert(introductionPageChangeLoggable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable,
        _introductionFinishLoggable = introductionFinishLoggable,
        _introductionFinishable = introductionFinishable,
        _introductionPageChangeLoggable = introductionPageChangeLoggable;

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  final IntroductionFinishLoggable _introductionFinishLoggable;

  final IntroductionFinishable _introductionFinishable;

  final IntroductionPageChangeLoggable _introductionPageChangeLoggable;

  IntroductionBloc create() => _IntroductionBloc(
        authenticatable: _authenticatable,
        cardSubscribable: _cardSubscribable,
        introductionFinishable: _introductionFinishable,
        introductionFinishLoggable: _introductionFinishLoggable,
        introductionPageChangeLoggable: _introductionPageChangeLoggable,
      );
}
