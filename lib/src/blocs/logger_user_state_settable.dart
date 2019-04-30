import 'package:meta/meta.dart';
import 'package:saraka/entities.dart' show User;
export 'package:saraka/entities.dart' show User;

mixin LoggerUserStateSettable {
  Future<void> setUserState({@required User user});
}
