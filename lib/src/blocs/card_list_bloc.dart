import 'package:rxdart/rxdart.dart';
import '../entities/card.dart';

export '../entities/card.dart';

abstract class CardListBloc {
  ValueObservable<List<Card>> get cards;

  void initialize();

  void dispose();
}
