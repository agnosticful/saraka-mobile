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

  CardList call(User user) => _CardList(
        user: user,
        repositoryService: _repositoryService,
      );
}

class _CardList extends CardList {
  _CardList({
    @required User user,
    @required RepositoryService repositoryService,
  })  : assert(user != null),
        assert(repositoryService != null),
        _user = user,
        _repositoryService = repositoryService;

  final User _user;

  final RepositoryService _repositoryService;

  final _onChange = StreamController<CardList>.broadcast();

  final List<Card> _cards = [];

  List<Card> get cards => _cards;

  Stream<CardList> get onChange => _onChange.stream;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    final cards = await _repositoryService.subscribeCards(user: _user).first;

    _cards.addAll(cards);
    _isInitialized = true;

    _onChange.add(this);
  }
}
