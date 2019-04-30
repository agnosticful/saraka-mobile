import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';
import '../blocs/card_create_loggable.dart';
import '../blocs/card_review_loggable.dart';
import '../blocs/introduction_finish_loggable.dart';
import '../blocs/introduction_page_change_loggable.dart';
import '../blocs/logger_user_state_settable.dart';
import '../blocs/sign_in_out_loggable.dart';
import '../blocs/synthesize_loggable.dart';

class FirebaseAnalyticsLogger
    implements
        CardCreateLoggable,
        CardReviewLoggable,
        IntroductionFinishLoggable,
        IntroductionPageChangeLoggable,
        LoggerUserStateSettable,
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
  Future<void> logCardCreateStart() =>
      _firebaseAnalytics.logEvent(name: 'card_create_start');

  @override
  Future<void> logCardReview({ReviewCertainty certainty}) =>
      _firebaseAnalytics.logEvent(
        name: 'card_review',
        parameters: {
          "certainty": certainty.toString(),
        },
      );

  @override
  Future<void> logCardReviewUndo() =>
      _firebaseAnalytics.logEvent(name: 'card_review_undo');

  @override
  Future<void> logIntroductionFinish() =>
      _firebaseAnalytics.logEvent(name: 'introduction_finish');

  @override
  Future<void> logIntroductionPageChange({@required String pageName}) =>
      _firebaseAnalytics.logEvent(
        name: "introduction_page_change",
        parameters: {"page": pageName},
      );

  @override
  Future<void> logSignIn() => _firebaseAnalytics.logLogin();

  @override
  Future<void> logSignOut() => _firebaseAnalytics.logEvent(name: 'logout');

  @override
  Future<void> logReviewStart({int cardLength}) => _firebaseAnalytics.logEvent(
        name: 'review_start',
        parameters: {
          "card_length": cardLength,
        },
      );

  @override
  Future<void> logReviewEnd({
    int cardLength,
    int reviewedCardLength,
  }) =>
      _firebaseAnalytics.logEvent(
        name: 'review_end',
        parameters: {
          "card_length": cardLength,
          "reviewed_card_length": reviewedCardLength,
          "remaining_card_length": cardLength - reviewedCardLength,
        },
      );

  @override
  Future<void> logSynthesize({String text}) => _firebaseAnalytics.logEvent(
        name: 'synthesize',
        parameters: {
          "text": text,
        },
      );

  @override
  Future<void> setUserState({User user}) =>
      _firebaseAnalytics.setUserId(user.id);
}
