import 'package:meta/meta.dart';
import './midway_introduction_finishable.dart';

abstract class MidwayIntroductionBloc {
  Future<void> finishMidwayIntroduction();
}

class _MidwayIntroductionBloc implements MidwayIntroductionBloc {
  _MidwayIntroductionBloc({
    @required this.session,
    @required this.midwayIntroductionFinishable,
  }) : assert(session != null);

  final AuthenticationSession session;

  final MidwayIntroductionFinishable midwayIntroductionFinishable;

  @override
  Future<void> finishMidwayIntroduction() => Future.wait([
        midwayIntroductionFinishable.finishMidwayIntroduction(session: session),
      ]);
}

class MidwayIntroductionBlocFactory {
  MidwayIntroductionBlocFactory({
    @required MidwayIntroductionFinishable midwayIntroductionFinishable,
  })  : assert(midwayIntroductionFinishable != null),
        _midwayIntroductionFinishable = midwayIntroductionFinishable;

  final MidwayIntroductionFinishable _midwayIntroductionFinishable;

  MidwayIntroductionBloc create({AuthenticationSession session}) =>
      _MidwayIntroductionBloc(
        session: session,
        midwayIntroductionFinishable: _midwayIntroductionFinishable,
      );
}
