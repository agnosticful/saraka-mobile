import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';
import '../entities/review.dart';

export '../entities/card.dart';
export '../entities/review.dart';

abstract class CardDetailBloc {
  Card get card;

  ValueObservable<List<Review>> get reviews;

  ValueObservable<bool> get isSpeechSoundLoaded;

  void speech();

  void initialize();

  void dispose();
}
