import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crashlytics/flutter_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/implementations.dart';
import 'package:saraka/widgets.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (buildMode == _BuildMode.debug) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await FlutterCrashlytics().initialize();

  Firestore.instance.settings(
    timestampsInSnapshotsEnabled: true,
    persistenceEnabled: false,
  );

  final firebaseAnalytics = FirebaseAnalytics();

  final authentication = FirebaseAuthentication(
    firebaseAuth: FirebaseAuth.instance,
    firestore: Firestore.instance,
    googleSignIn: GoogleSignIn(),
  );

  final backendVersionRepository = FirestoreBackendVersionRepository(
    firestore: Firestore.instance,
  );

  final cacheStorage = CacheStorage();

  final logger = FirebaseAnalyticsLogger(firebaseAnalytics: firebaseAnalytics);

  final cardRepository = FirestoreCardRepository(
    firestore: Firestore.instance,
  );

  final maintenanceRepository = FirestoreMaintenanceRepository(
    firestore: Firestore.instance,
  );

  final firebaseExternalFunctions = FirebaseExternalFunctions(
    cloudFunctions: CloudFunctions.instance,
  );

  final userRepository = FirestoreUserRepository(firestore: Firestore.instance);

  final soundPlayer = SoundPlayer();

  final authenticationBlocFactory = AuthenticationBlocFactory(
    authenticatable: authentication,
    signable: authentication,
    signInOutLoggable: logger,
  );

  final backendVersionCompatibilityCheckBlocFactory =
      BackendVersionCompatibilityCheckBlocFactory(
    backendVersionGetable: backendVersionRepository,
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
            Provider<MaintenanceCheckBloc>(value: maintenanceCheckBloc),
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
