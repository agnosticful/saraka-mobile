import 'package:meta/meta.dart';
import 'package:saraka/entities.dart' show User;
export 'package:saraka/entities.dart' show User;

mixin IntroductionFinishable {
  Future<void> finishIntroduction({@required User user});
}
