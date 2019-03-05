import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';

abstract class RepositoryService {
  Future<void> addNewCard({@required User user, @required String text});

  Stream<List<Card>> subscribeCards({@required User user});
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.word);

  final String word;

  String get message =>
      "CardDuplicationException: there's already $word added.";
}
