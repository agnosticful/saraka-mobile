import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
export '../entities/authentication_session.dart';

abstract class MidwayIntroductionFinishable {
  Future<void> finishMidwayIntroduction(
      {@required AuthenticationSession session});
}
