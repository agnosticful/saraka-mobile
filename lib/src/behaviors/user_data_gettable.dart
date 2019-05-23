import 'package:meta/meta.dart';
import '../entities/authentication_session.dart';

abstract class UserDataGettable {
  Future<UserData> getUserData({@required AuthenticationSession session});
}

abstract class UserData {
  bool get isIntroductionFinished;
}
