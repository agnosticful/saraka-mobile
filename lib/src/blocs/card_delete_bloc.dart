import '../entities/card.dart';

export '../entities/card.dart';

abstract class CardDeleteBloc {
  Card get card;

  Future<void> delete();

  void initialize();

  void dispose();
}
