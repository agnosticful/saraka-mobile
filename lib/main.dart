import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import './src/implementations/cache_storage.dart';
import './src/implementations/firebase_analytics_logger.dart';
import './src/implementations/firebase_authentication.dart';
import './src/implementations/firebase_external_functions.dart';
import './src/implementations/firestore_card_repository.dart';
import './src/implementations/sound_player.dart';
import './src/implementations/url_launcher.dart';
import './src/view/foundation/application.dart';
import './src/view/foundation/navigator.dart';

void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /**
   * External APIs
   */
  final firebaseAnalytics = FirebaseAnalytics();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = Firestore.instance
    ..settings(
      timestampsInSnapshotsEnabled: true,
      // persistenceEnabled: false,
    );
  final googleSignIn = GoogleSignIn();

  /**
   * Implementations
   */
  final authentication = FirebaseAuthentication(
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
  );
  final cacheStorage = CacheStorage();
  final cardRepository = FirestoreCardRepository(firestore: firestore);
  final firebaseExternalFunctions = FirebaseExternalFunctions(
    cloudFunctions: CloudFunctions.instance,
  );
  final logger = FirebaseAnalyticsLogger(firebaseAnalytics: firebaseAnalytics);
  final soundPlayer = SoundPlayer();
  final urlLauncher = UrlLauncher();

  /**
   * BLoCs
   */
  final authenticationBlocFactory = AuthenticationBlocFactory(
    signable: authentication,
    signInOutLoggable: logger,
  );
  final commonLinkBloc = CommonLinkBloc(
    urlLaunchable: urlLauncher,
    privacyPolicyUrl: privacyPolicyUrl,
  );
  final cardCreateBlocFactory = CardCreateBlocFactory(
    cardCreatable: firebaseExternalFunctions,
    cardCreateLoggable: logger,
  );
  final cardDeleteBlocFactory = CardDeleteBlocFactory(
    cardDeletable: cardRepository,
  );
  final cardDetailBlocFactory = CardDetailBlocFactory(
    reviewSubscribable: cardRepository,
  );
  final cardReviewBlocFactory = CardReviewBlocFactory(
    cardReviewable: firebaseExternalFunctions,
    cardReviewLoggable: logger,
    inQueueCardSubscribable: cardRepository,
  );
  final cardListBlocFactory = CardListBlocFactory(
    cardSubscribable: cardRepository,
  );
  final synthesizerBlocFactory = SynthesizerBlocFactory(
    soundFilePlayable: soundPlayer,
    synthesizable: firebaseExternalFunctions,
    synthesizedSoundFileReferable: cacheStorage,
    synthesizeLoggable: logger,
  );
  final authenticationBloc = authenticationBlocFactory.create();

  runApp(
    MultiProvider(
      providers: [
        Provider<CardCreateBlocFactory>(
            builder: (context) => cardCreateBlocFactory),
        Provider<CardDeleteBlocFactory>(
            builder: (context) => cardDeleteBlocFactory),
        Provider<CardDetailBlocFactory>(
            builder: (context) => cardDetailBlocFactory),
        Provider<CardReviewBlocFactory>(
            builder: (context) => cardReviewBlocFactory),
        Provider<CardListBlocFactory>(
            builder: (context) => cardListBlocFactory),
        Provider<SynthesizerBlocFactory>(
            builder: (context) => synthesizerBlocFactory),
        Provider<AuthenticationBloc>(
            builder: (context) => authenticationBloc..restoreSession()),
        Provider<CommonLinkBloc>(builder: (context) => commonLinkBloc),
      ],
      child: Application(
        title: "Parrot",
        color: SarakaColor.lightRed,
        child: SarakaNavigator(
          observers: [
            FirebaseAnalyticsObserver(
              analytics: firebaseAnalytics,
              nameExtractor: (routeSettings) =>
                  SarakaNavigator.extractRouteName(
                    routeSettings,
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}
