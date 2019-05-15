import 'package:meta/meta.dart';

abstract class SynthesizeLoggable {
  Future<void> logSynthesize({@required String text});
}
