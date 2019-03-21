import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/implementations.dart';
import './application.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

  final firebaseAnalytics = FirebaseAnalytics();

  final authentication = TrackedFirebaseAuthentication(
    firebaseAnalytics: firebaseAnalytics,
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
  );

  final cacheStorage = CacheStorage();

  final cardRepository = FirestoreCardRepository(
    firestore: Firestore.instance,
  );

  final firebaseExternalFunctions = TrackedFirebaseExternalFunctions(
    firebaseAnalytics: firebaseAnalytics,
    cloudFunctions: CloudFunctions.instance,
  );

  final soundPlayer = SoundPlayer();

  final authenticationBlocFactory = AuthenticationBlocFactory(
    authenticatable: authentication,
    signable: authentication,
  );

  final cardAdderBlocFactory = CardAdderBlocFactory(
    authenticatable: authentication,
    cardAddable: firebaseExternalFunctions,
  );

  final cardStudyBlocFactory = CardStudyBlocFactory(
    authenticatable: authentication,
    cardStudyable: firebaseExternalFunctions,
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
  );

  final authenticationBloc = authenticationBlocFactory.create();

  runApp(
    MultiProvider(
      providers: [
        Provider<CardAdderBlocFactory>(value: cardAdderBlocFactory),
        Provider<CardStudyBlocFactory>(value: cardStudyBlocFactory),
        Provider<CardListBlocFactory>(value: cardListBlocFactory),
        Provider<SynthesizerBlocFactory>(value: synthesizerBlocFactory),
        Provider<AuthenticationBloc>(value: authenticationBloc),
      ],
      child: Application(),
    ),
  );
}
