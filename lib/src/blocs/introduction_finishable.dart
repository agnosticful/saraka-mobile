import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';
export '../entities/authentication_session.dart';

mixin IntroductionFinishable {
  Future<void> finishIntroduction({@required AuthenticationSession session});
}
