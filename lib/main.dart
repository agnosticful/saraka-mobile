import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import './src/blocs/authentication_bloc.dart';
import './src/blocs/backend_version_compatibility_check_bloc.dart';
import './src/blocs/common_link_bloc.dart';
import './src/blocs/introduction_bloc.dart';
import './src/blocs/maintenance_check_bloc.dart';
import './src/blocs/card_adder_bloc.dart';
import './src/blocs/card_delete_bloc.dart';
import './src/blocs/card_detail_bloc.dart';
import './src/blocs/card_review_bloc.dart';
import './src/blocs/card_list_bloc.dart';
import './src/blocs/synthesizer_bloc.dart';
import './src/blocs/article_list_bloc.dart';
import './src/implementations/cache_storage.dart';
import './src/implementations/firebase_analytics_logger.dart';
import './src/implementations/firebase_authentication.dart';
import './src/implementations/firebase_external_functions.dart';
import './src/implementations/firestore_backend_version_repository.dart';
import './src/implementations/firestore_card_repository.dart';
import './src/implementations/firestore_maintenance_repository.dart';
import './src/implementations/firestore_user_repository.dart';
import './src/implementations/sound_player.dart';
import './src/implementations/url_launcher.dart';
import './src/implementations/prismic_io_article_repository.dart';
import './src/widgets/application.dart';
import './src/widgets/authentication_navigator.dart';
import './src/widgets/backend_version_check_navigator.dart';
import './src/widgets/card_list_screen.dart';
import './src/widgets/dashboard_screen.dart';
import './src/widgets/introduction_screen.dart';
import './src/widgets/landing_screen.dart';
import './src/widgets/maintenance_check_navigator.dart';
import './src/widgets/review_screen.dart';
import './src/widgets/signed_in_navigator.dart';
import './src/widgets/signed_out_screen.dart';
import './src/widgets/article_list_screen.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (buildMode == _BuildMode.debug) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FlutterCrashlytics().initialize();

  /**
   * External APIs
   */
  final firebaseAnalytics = FirebaseAnalytics();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = Firestore.instance
    ..settings(
      timestampsInSnapshotsEnabled: true,
      persistenceEnabled: false,
    );
  final googleSignIn = GoogleSignIn();

  /**
   * Implementations
   */
  final authentication = FirebaseAuthentication(
    firebaseAuth: firebaseAuth,
    firestore: firestore,
    googleSignIn: googleSignIn,
  );
  final backendVersionRepository = FirestoreBackendVersionRepository(
    firestore: firestore,
  );
  final cacheStorage = CacheStorage();
  final cardRepository = FirestoreCardRepository(firestore: firestore);
  final firebaseExternalFunctions = FirebaseExternalFunctions(
    cloudFunctions: CloudFunctions.instance,
  );
  final logger = FirebaseAnalyticsLogger(firebaseAnalytics: firebaseAnalytics);
  final maintenanceRepository = FirestoreMaintenanceRepository(
    firestore: firestore,
  );
  final userRepository = FirestoreUserRepository(firestore: Firestore.instance);
  final soundPlayer = SoundPlayer();
  final urlLauncher = UrlLauncher();
  final articleRepository = PrismicIoArticleRepository();

  /**
   * BLoCs
   */
  final authenticationBlocFactory = AuthenticationBlocFactory(
    authenticatable: authentication,
    loggerUserStateSettable: logger,
    signable: authentication,
    signInOutLoggable: logger,
  );
  final backendVersionCompatibilityCheckBlocFactory =
      BackendVersionCompatibilityCheckBlocFactory(
    backendVersionGettable: backendVersionRepository,
  );
  final commonLinkBloc = CommonLinkBloc(
    urlLaunchable: urlLauncher,
    privacyPolicyUrl: privacyPolicyUrl,
  );
  final firstCardListBlocFactory = IntroductionBlocFactory(
    authenticatable: authentication,
    cardSubscribable: cardRepository,
    introductionFinishable: userRepository,
    introductionFinishLoggable: logger,
    introductionPageChangeLoggable: logger,
  );
  final maintenanceCheckBlocFactory = MaintenanceCheckBlocFactory(
    maintenanceSubscribable: maintenanceRepository,
  );
  final cardAdderBlocFactory = CardAdderBlocFactory(
    authenticatable: authentication,
    cardAddable: firebaseExternalFunctions,
    cardCreateLoggable: logger,
  );
  final cardDeleteBlocFactory = CardDeleteBlocFactory(
    authenticatable: authentication,
    cardDeletable: cardRepository,
  );
  final cardDetailBlocFactory = CardDetailBlocFactory(
    authenticatable: authentication,
    reviewSubscribable: cardRepository,
  );
  final cardReviewBlocFactory = CardReviewBlocFactory(
    authenticatable: authentication,
    cardReviewable: firebaseExternalFunctions,
    cardReviewLoggable: logger,
    inQueueCardSubscribable: cardRepository,
  );
  final cardListBlocFactory = CardListBlocFactory(
    authenticatable: authentication,
    cardSubscribable: cardRepository,
  );
  final synthesizerBlocFactory = SynthesizerBlocFactory(
    soundFilePlayable: soundPlayer,
    synthesizable: firebaseExternalFunctions,
    synthesizedSoundFileReferable: cacheStorage,
    synthesizeLoggable: logger,
  );
  final authenticationBloc = authenticationBlocFactory.create();
  final backendVersionCompatibilityCheckBloc =
      backendVersionCompatibilityCheckBlocFactory.create();
  final maintenanceCheckBloc = maintenanceCheckBlocFactory.create();

  final articleListBlocFactory =
      ArticleListBlocFactory(articleGettable: articleRepository);

  runZoned<Future<Null>>(
    () async {
      runApp(
        MultiProvider(
          providers: [
            Provider<CardAdderBlocFactory>(value: cardAdderBlocFactory),
            Provider<CardDeleteBlocFactory>(value: cardDeleteBlocFactory),
            Provider<CardDetailBlocFactory>(value: cardDetailBlocFactory),
            Provider<CardReviewBlocFactory>(value: cardReviewBlocFactory),
            Provider<CardListBlocFactory>(value: cardListBlocFactory),
            Provider<IntroductionBlocFactory>(value: firstCardListBlocFactory),
            Provider<SynthesizerBlocFactory>(value: synthesizerBlocFactory),
            Provider<AuthenticationBloc>(value: authenticationBloc),
            Provider<BackendVersionCompatibilityCheckBloc>(
              value: backendVersionCompatibilityCheckBloc,
            ),
            Provider<CommonLinkBloc>(value: commonLinkBloc),
            Provider<MaintenanceCheckBloc>(value: maintenanceCheckBloc),
            Provider<ArticleListBlocFactory>(value: articleListBlocFactory),
          ],
          child: Application(
            title: "Parrot",
            color: SarakaColors.lightRed,
            child: BackendVersionCheckNavigator(
              observers: [
                FirebaseAnalyticsObserver(
                  analytics: firebaseAnalytics,
                  nameExtractor: (routeSettings) =>
                      BackendVersionCheckNavigator.extractRouteName(
                        routeSettings,
                      ),
                ),
              ],
              builder: (context) => MaintenanceCheckNavigator(
                    observers: [
                      FirebaseAnalyticsObserver(
                        analytics: firebaseAnalytics,
                        nameExtractor: (routeSettings) =>
                            MaintenanceCheckNavigator.extractRouteName(
                              routeSettings,
                            ),
                      ),
                    ],
                    builder: (context) => AuthenticationNavigator(
                          observers: [
                            FirebaseAnalyticsObserver(
                              analytics: firebaseAnalytics,
                              nameExtractor: (routeSettings) =>
                                  AuthenticationNavigator.extractRouteName(
                                    routeSettings,
                                  ),
                            ),
                          ],
                          signedInBuilder: (context) => SignedInNavigator(
                                observers: [
                                  FirebaseAnalyticsObserver(
                                    analytics: firebaseAnalytics,
                                    nameExtractor: (routeSettings) =>
                                        SignedInNavigator.extractRouteName(
                                          routeSettings,
                                        ),
                                  ),
                                ],
                                cardListBuilder: (context) => CardListScreen(),
                                introductionBuilder: (context) =>
                                    IntroductionScreen(),
                                dashboardBuilder: (context) =>
                                    DashboardScreen(),
                                reviewBuilder: (context, showTutorial) =>
                                    ReviewScreen(
                                      showTutorial: showTutorial,
                                    ),
                                articleListBuilder: (context) =>
                                    ArticleListScreen(),
                              ),
                          signedOutBuilder: (context) => SignedOutScreen(),
                          undecidedBuilder: (context) => LandingScreen(),
                        ),
                  ),
            ),
          ),
        ),
      );
    },
    onError: (error, stackTrace) async {
      debugPrint(error);
      debugPrint(stackTrace);

      // Whenever an error occurs, call the `reportCrash` function. This will send Dart errors to our dev console or Crashlytics depending on the environment.
      await FlutterCrashlytics().reportCrash(
        error,
        stackTrace,
        forceCrash: false,
      );
    },
  );
}

_BuildMode buildMode = (() {
  if (const bool.fromEnvironment('dart.vm.product')) {
    return _BuildMode.release;
  }

  var result = _BuildMode.profile;

  // assert functions will run only on debug mode.
  assert(() {
    result = _BuildMode.debug;

    return true;
  }());

  // if neither of above, it's on profile mode
  return result;
}());

enum _BuildMode {
  release,
  profile,
  debug,
}
