import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/constants.dart';
import '../entities/card.dart';
import '../behaviors/card_subscribable.dart';
import '../behaviors/introduction_finish_loggable.dart';
import '../behaviors/introduction_finishable.dart';
import '../behaviors/introduction_page_change_loggable.dart';
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
    @required this.session,
    @required this.cardSubscribable,
    @required this.introductionFinishLoggable,
    @required this.introductionFinishable,
    @required this.introductionPageChangeLoggable,
  })  : assert(session != null),
        assert(cardSubscribable != null),
        assert(introductionFinishLoggable != null),
        assert(introductionFinishable != null),
        assert(introductionPageChangeLoggable != null) {
    final subscription =
        cardSubscribable.subscribeCards(session: session).listen((cards) {
      firstCards.add(cards.take(necessaryFirstCardLength).toList());
      isEnoughCardsAdded.add(cards.length >= necessaryFirstCardLength);
    });

    firstCards.onCancel =
        () => !firstCards.hasListener ?? subscription.cancel();

    isEnoughCardsAdded.onCancel =
        () => !isEnoughCardsAdded.hasListener ?? subscription.cancel();
  }

  final AuthenticationSession session;

  final CardSubscribable cardSubscribable;

  final IntroductionFinishLoggable introductionFinishLoggable;

  final IntroductionFinishable introductionFinishable;

  final IntroductionPageChangeLoggable introductionPageChangeLoggable;

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
      introductionPageChangeLoggable.logIntroductionPageChange(
          pageName: pageName);

  @override
  Future<void> finishIntroduction() => Future.wait([
        introductionFinishable.finishIntroduction(session: session),
        introductionFinishLoggable.logIntroductionFinish(),
      ]);
}

class IntroductionBlocFactory {
  IntroductionBlocFactory({
    @required CardSubscribable cardSubscribable,
    @required IntroductionFinishLoggable introductionFinishLoggable,
    @required IntroductionFinishable introductionFinishable,
    @required IntroductionPageChangeLoggable introductionPageChangeLoggable,
  })  : assert(cardSubscribable != null),
        assert(introductionFinishLoggable != null),
        assert(introductionFinishable != null),
        assert(introductionPageChangeLoggable != null),
        _cardSubscribable = cardSubscribable,
        _introductionFinishLoggable = introductionFinishLoggable,
        _introductionFinishable = introductionFinishable,
        _introductionPageChangeLoggable = introductionPageChangeLoggable;

  final CardSubscribable _cardSubscribable;

  final IntroductionFinishLoggable _introductionFinishLoggable;

  final IntroductionFinishable _introductionFinishable;

  final IntroductionPageChangeLoggable _introductionPageChangeLoggable;

  IntroductionBloc create({AuthenticationSession session}) => _IntroductionBloc(
        session: session,
        cardSubscribable: _cardSubscribable,
        introductionFinishable: _introductionFinishable,
        introductionFinishLoggable: _introductionFinishLoggable,
        introductionPageChangeLoggable: _introductionPageChangeLoggable,
      );
}
