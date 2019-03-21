import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import 'package:saraka/blocs.dart';

class FirebaseAnalyticsLogger
    implements
        CardCreateLoggable,
        CardStudyLoggable,
        SignInOutLoggable,
        SynthesizeLoggable {
  FirebaseAnalyticsLogger({@required FirebaseAnalytics firebaseAnalytics})
      : assert(firebaseAnalytics != null),
        _firebaseAnalytics = firebaseAnalytics;

  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Future<void> logCardCreate({@required String text}) =>
      _firebaseAnalytics.logEvent(name: 'card_create');

  @override
  Future<void> logCardStudy({StudyCertainty certainty}) =>
      _firebaseAnalytics.logEvent(
        name: 'card_study',
        parameters: {
          "certainty": _buildCertaintyString(certainty),
        },
      );

  @override
  Future<void> logSignIn() => _firebaseAnalytics.logLogin();

  @override
  Future<void> logSignOut() => _firebaseAnalytics.logEvent(name: 'logout');

  @override
  Future<void> logSynthesize({String text}) => _firebaseAnalytics.logEvent(
        name: 'synthesize',
        parameters: {
          "text": text,
        },
      );
}

String _buildCertaintyString(StudyCertainty certainty) {
  switch (certainty) {
    case StudyCertainty.good:
      return "GOOD";
    case StudyCertainty.vague:
      return "VAGUE";
  }

  assert(false);
}
