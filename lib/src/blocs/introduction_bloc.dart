import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';
import './commons/card_subscribable.dart';

export './commons/authenticatable.dart';
export './commons/card_subscribable.dart';

class IntroductionBlocFactory {
  IntroductionBlocFactory({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
    @required IntroductionFinishable introductionFinishable,
    @required IntroductionFinishLoggable introductionFinishLoggable,
    @required IntroductionPageChangeLoggable introductionPageChangeLoggable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        assert(introductionFinishable != null),
        assert(introductionFinishLoggable != null),
        assert(introductionPageChangeLoggable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable,
        _introductionFinishable = introductionFinishable,
        _introductionFinishLoggable = introductionFinishLoggable,
        _introductionPageChangeLoggable = introductionPageChangeLoggable;

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  final IntroductionFinishable _introductionFinishable;

  final IntroductionFinishLoggable _introductionFinishLoggable;

  final IntroductionPageChangeLoggable _introductionPageChangeLoggable;

  IntroductionBloc create() => _IntroductionBloc(
        authenticatable: _authenticatable,
        cardSubscribable: _cardSubscribable,
        introductionFinishable: _introductionFinishable,
        introductionFinishLoggable: _introductionFinishLoggable,
        introductionPageChangeLoggable: _introductionPageChangeLoggable,
      );
}

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
    @required IntroductionFinishable introductionFinishable,
    @required IntroductionFinishLoggable introductionFinishLoggable,
    @required IntroductionPageChangeLoggable introductionPageChangeLoggable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        assert(introductionFinishable != null),
        assert(introductionFinishLoggable != null),
        assert(introductionPageChangeLoggable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable,
        _introductionFinishable = introductionFinishable,
        _introductionFinishLoggable = introductionFinishLoggable,
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

  final IntroductionFinishable _introductionFinishable;

  final IntroductionFinishLoggable _introductionFinishLoggable;

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

mixin IntroductionFinishable {
  Future<void> finishIntroduction({@required User user});
}

mixin IntroductionFinishLoggable {
  Future<void> logIntroductionFinish();
}

mixin IntroductionPageChangeLoggable {
  Future<void> logIntroductionPageChange({@required String pageName});
}
