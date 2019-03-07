import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';

abstract class RepositoryService {
  Stream<List<Card>> subscribeCards({@required User user});

  Future<void> addNewCard({@required User user, @required String text});

  Future<void> logLearning({
    @required User user,
    @required Card card,
    @required Duration interval,
    @required LearningCertainty certainty,
  });

  Future<void> undoLearning({
    @required User user,
    @required Card card,
  });
}

class CardDuplicationException implements Exception {
  CardDuplicationException(this.word);

  final String word;

  String get message =>
      "CardDuplicationException: there's already $word added.";
}
