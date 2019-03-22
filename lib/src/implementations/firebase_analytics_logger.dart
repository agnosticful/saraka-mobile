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
          "certainty": certainty.toString(),
        },
      );

  @override
  Future<void> logSignIn() => _firebaseAnalytics.logLogin();

  @override
  Future<void> logSignOut() => _firebaseAnalytics.logEvent(name: 'logout');

  @override
  Future<void> logStudyStart({int cardLength}) => _firebaseAnalytics.logEvent(
        name: 'study_start',
        parameters: {
          "card_length": cardLength,
        },
      );

  @override
  Future<void> logStudyEnd({
    int cardLength,
    int studiedCardLength,
  }) =>
      _firebaseAnalytics.logEvent(
        name: 'study_end',
        parameters: {
          "card_length": cardLength,
          "studied_card_length": studiedCardLength,
          "remaining_card_length": cardLength - studiedCardLength,
        },
      );

  @override
  Future<void> logSynthesize({String text}) => _firebaseAnalytics.logEvent(
        name: 'synthesize',
        parameters: {
          "text": text,
        },
      );
}
