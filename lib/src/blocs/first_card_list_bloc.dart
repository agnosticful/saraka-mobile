import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';
import './commons/card_subscribable.dart';

export './commons/authenticatable.dart';
export './commons/card_subscribable.dart';

class FirstCardListBlocFactory {
  FirstCardListBlocFactory({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
    @required IntroductionFinishable introductionFinishable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        assert(introductionFinishable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable,
        _introductionFinishable = introductionFinishable;

  final Authenticatable _authenticatable;

  final CardSubscribable _cardSubscribable;

  final IntroductionFinishable _introductionFinishable;

  FirstCardListBloc create() => _FirstCardListBloc(
        authenticatable: _authenticatable,
        cardSubscribable: _cardSubscribable,
        introductionFinishable: _introductionFinishable,
      );
}

abstract class FirstCardListBloc {
  ValueObservable<List<Card>> get firstCards;

  ValueObservable<bool> get isEnoughCardsAdded;

  BehaviorSubject<bool> get hasAlreadyOpenedNewCardDialogAutomatically;

  Future<void> finishIntroduction();
}

class _FirstCardListBloc implements FirstCardListBloc {
  _FirstCardListBloc({
    @required Authenticatable authenticatable,
    @required CardSubscribable cardSubscribable,
    @required IntroductionFinishable introductionFinishable,
  })  : assert(authenticatable != null),
        assert(cardSubscribable != null),
        assert(introductionFinishable != null),
        _authenticatable = authenticatable,
        _cardSubscribable = cardSubscribable,
        _introductionFinishable = introductionFinishable {
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

  @override
  final BehaviorSubject<List<Card>> firstCards = BehaviorSubject();

  @override
  final BehaviorSubject<bool> isEnoughCardsAdded = BehaviorSubject();

  @override
  final hasAlreadyOpenedNewCardDialogAutomatically =
      BehaviorSubject.seeded(false);

  @override
  Future<void> finishIntroduction() => _introductionFinishable
      .finishIntroduction(user: _authenticatable.user.value);
}

mixin IntroductionFinishable {
  Future<void> finishIntroduction({@required User user});
}
