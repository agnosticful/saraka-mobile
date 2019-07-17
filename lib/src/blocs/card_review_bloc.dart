import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';

export '../entities/card.dart';

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
