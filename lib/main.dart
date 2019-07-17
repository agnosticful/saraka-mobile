import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import './src/blocs/authentication_bloc.dart';
import './src/blocs/common_link_bloc.dart';
import './src/bloc_factories/authentication_bloc_factory.dart';
import './src/bloc_factories/card_create_bloc_factory.dart';
import './src/bloc_factories/card_delete_bloc_factory.dart';
import './src/bloc_factories/card_detail_bloc_factory.dart';
import './src/bloc_factories/card_list_bloc_factory.dart';
import './src/bloc_factories/card_review_bloc_factory.dart';
import './src/bloc_factories/common_link_bloc_factory.dart';
import './src/bloc_factories/new_card_edit_bloc_factory.dart';
import './src/services/card_command_service.dart';
import './src/services/card_query_service.dart';
import './src/services/firebase_authentication.dart';
import './src/services/review_command_service.dart';
import './src/services/review_query_service.dart';
import './src/services/text_speech_service.dart';
import './src/services/url_open_service.dart';
import './src/view/foundation/application.dart';
import './src/view/foundation/navigator.dart';

void main() async {
  // force screen orientation only portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //
  // external APIs
  //
  final firebaseAnalytics = FirebaseAnalytics();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = Firestore.instance
    ..settings(
      timestampsInSnapshotsEnabled: true,
      // persistenceEnabled: false,
    );
  final googleSignIn = GoogleSignIn();

  //
  // services
  //
  final firebaseAuthentication = FirebaseAuthentication(
    firebaseAuth: firebaseAuth,
    googleSignIn: googleSignIn,
  );
  final cardCommandService = CardCommandService(
    cloudFunctions: CloudFunctions.instance,
    firestore: firestore,
  );
  final cardQueryService = CardQueryService(
    firestore: firestore,
  );
  final reviewCommandService =
      ReviewCommandService(cloudFunctions: CloudFunctions.instance);
  final reviewQueryService = ReviewQueryService(firestore: firestore);
  final textSpeechService = TextSpeechService(
    audioPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY),
    cloudFunctions: CloudFunctions.instance,
  );
  final urlOpenService = UrlOpenService();

  //
  // bloc factories
  //
  final authenticationBlocFactory = AuthenticationBlocFactory(
    signable: firebaseAuthentication,
  );
  final cardCreateBlocFactory = CardCreateBlocFactory(
    cardCreatable: cardCommandService,
  );
  final cardDeleteBlocFactory = CardDeleteBlocFactory(
    cardDeletable: cardCommandService,
  );
  final cardDetailBlocFactory = CardDetailBlocFactory(
    cardReviewListable: reviewQueryService,
    textSpeechable: textSpeechService,
  );
  final cardListBlocFactory = CardListBlocFactory(
    cardListable: cardQueryService,
  );
  final cardReviewBlocFactory = CardReviewBlocFactory(
    cardReviewable: reviewCommandService,
    inQueueCardListable: cardQueryService,
  );
  final commonLinkBlocFactory = CommonLinkBlocFactory(
    urlOpenable: urlOpenService,
    privacyPolicyUrl: privacyPolicyUrl,
  );
  final newCardEditBlocFactory =
      NewCardEditBlocFactory(textSpeechable: textSpeechService);

  //
  // global blocs
  //
  final authenticationBloc = authenticationBlocFactory.create();
  final commonLinkBloc = commonLinkBlocFactory.create();

  runApp(
    MultiProvider(
      providers: [
        Provider<CardCreateBlocFactory>(builder: (_) => cardCreateBlocFactory),
        Provider<CardDeleteBlocFactory>(builder: (_) => cardDeleteBlocFactory),
        Provider<CardDetailBlocFactory>(builder: (_) => cardDetailBlocFactory),
        Provider<CardListBlocFactory>(builder: (_) => cardListBlocFactory),
        Provider<CardReviewBlocFactory>(builder: (_) => cardReviewBlocFactory),
        Provider<NewCardEditBlocFactory>(
            builder: (_) => newCardEditBlocFactory),
        Provider<AuthenticationBloc>(
          builder: (_) => authenticationBloc
            ..initialize()
            ..restoreSession(),
          dispose: (_, authenticationBloc) => authenticationBloc.dispose(),
        ),
        Provider<CommonLinkBloc>(
          builder: (_) => commonLinkBloc..initialize(),
          dispose: (_, commonLinkBloc) => commonLinkBloc.dispose(),
        ),
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
