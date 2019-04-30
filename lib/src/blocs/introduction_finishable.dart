import 'package:meta/meta.dart';
import '../entities/user.dart';
export '../entities/user.dart';

mixin IntroductionFinishable {
  Future<void> finishIntroduction({@required User user});
}
