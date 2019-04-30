import 'package:meta/meta.dart';
import '../entities/user.dart';
export '../entities/user.dart';

mixin LoggerUserStateSettable {
  Future<void> setUserState({@required User user});
}
