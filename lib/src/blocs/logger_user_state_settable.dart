import 'package:meta/meta.dart';
import '../entities/user.dart';
export '../entities/user.dart';

abstract class LoggerUserStateSettable {
  Future<void> setUserState({@required User user});
}
