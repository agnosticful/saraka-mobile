import 'package:saraka/domains.dart';

abstract class CardList {
  List<Card> get cards;

  Stream<CardList> get onChange;

  bool get isInitialized;

  Future<void> initialize();
}
