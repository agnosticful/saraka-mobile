import 'dart:async';
import 'package:meta/meta.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';

class CardListUsecase {
  CardListUsecase({
    @required RepositoryService repositoryService,
  })  : assert(repositoryService != null),
        _repositoryService = repositoryService;

  final RepositoryService _repositoryService;

  Future<CardList> call(User user) async => _CardList(
        user: user,
        repositoryService: _repositoryService,
        cards: await _repositoryService.subscribeCards(user: user).first,
      );
}

class _CardList extends CardList {
  _CardList({
    @required User user,
    @required RepositoryService repositoryService,
    @required List<Card> cards,
  })  : assert(user != null),
        assert(repositoryService != null),
        assert(cards != null),
        _user = user,
        _repositoryService = repositoryService;

  final User _user;

  final RepositoryService _repositoryService;

  Stream<List<Card>> get cards =>
      _repositoryService.subscribeCards(user: _user);
}
