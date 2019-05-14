import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
export '../entities/authentication_session.dart';

abstract class IntroductionFinishable {
  Future<void> finishIntroduction({@required AuthenticationSession session});
}
