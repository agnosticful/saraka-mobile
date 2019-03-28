import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saraka/entities.dart';
import './commons/authenticatable.dart';

export 'package:saraka/entities.dart' show Study;

class CardDetailBlocFactory {
  CardDetailBlocFactory({
    @required Authenticatable authenticatable,
    @required StudySubscribable studySubscribable,
  })  : assert(authenticatable != null),
        assert(studySubscribable != null),
        _authenticatable = authenticatable,
        _studySubscribable = studySubscribable;

  final Authenticatable _authenticatable;

  final StudySubscribable _studySubscribable;

  CardDetailBloc create(Card card) => _CardDetailBloc(
        card: card,
        authenticatable: _authenticatable,
        studySubscribable: _studySubscribable,
      );
}

abstract class CardDetailBloc {
  Card get card;

  ValueObservable<List<Study>> get studies;
}

class _CardDetailBloc implements CardDetailBloc {
  _CardDetailBloc({
    @required this.card,
    @required Authenticatable authenticatable,
    @required StudySubscribable studySubscribable,
  })  : assert(card != null),
        assert(authenticatable != null),
        assert(studySubscribable != null),
        _authenticatable = authenticatable,
        _studySubscribable = studySubscribable;

  @override
  final Card card;

  final Authenticatable _authenticatable;

  final StudySubscribable _studySubscribable;

  @override
  ValueObservable<List<Study>> get studies =>
      _studySubscribable.subscribeStudiesInCard(
        user: _authenticatable.user.value,
        card: card,
      );
}

mixin StudySubscribable {
  Observable<List<Study>> subscribeStudiesInCard({
    @required User user,
    @required Card card,
  });
}
