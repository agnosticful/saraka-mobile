import 'package:meta/meta.dart';

abstract class IntroductionPageChangeLoggable {
  Future<void> logIntroductionPageChange({@required String pageName});
}
