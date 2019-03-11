import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/implementations.dart';
import './application.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

  final authentication = FirebaseAuthentication(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
  );

  final cacheStorage = CacheStorage();

  final cardRepository = FirestoreCardRepository(
    firestore: Firestore.instance,
  );

  final firebaseExternalFunctions = FirebaseExternalFunctions(
    cloudFunctions: CloudFunctions.instance,
  );

  final soundPlayer = SoundPlayer();

  final authenticationBlocFactory = AuthenticationBlocFactory(
    authenticatable: authentication,
    signable: authentication,
  );

  final cardAdderBlocFactory = CardAdderBlocFactory(
    authenticatable: authentication,
    cardAddable: cardRepository,
  );

  final cardLearningBlocFactory = CardLearningBlocFactory(
    authenticatable: authentication,
    cardLearnable: cardRepository,
    cardSubscribable: cardRepository,
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
        Provider<CardLearningBlocFactory>(value: cardLearningBlocFactory),
        Provider<CardListBlocFactory>(value: cardListBlocFactory),
        Provider<SynthesizerBlocFactory>(value: synthesizerBlocFactory),
        Provider<AuthenticationBloc>(value: authenticationBloc),
      ],
      child: Application(),
    ),
  );
}
