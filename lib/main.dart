import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';
import 'package:saraka/usecases.dart';
import './application.dart';

void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

  final repositoryService = CloudFirestoreService(
    firestore: Firestore.instance,
  );
  final dataPersistentService = ApplicationStorageService();
  final externalFunctionService = FirebaseFunctionService(
    functions: CloudFunctions.instance,
  );

  final authenticationUsecase = AuthenticationUsecase(
    authenticationService: FirebaseAuthenticationService(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    ),
  );

  final cardListUsecase = CardListUsecase(repositoryService: repositoryService);

  final newCardUsecase = NewCardUsecase(
    dataPersistentService: dataPersistentService,
    externalFunctionService: externalFunctionService,
    repositoryService: repositoryService,
  );

  final textSynthesizationUsecase = TextSynthesizationUsecase(
    dataPersistentService: dataPersistentService,
    externalFunctionService: externalFunctionService,
  );

  final authentication = authenticationUsecase();

  runApp(
    MultiProvider(
      providers: [
        Provider<Authentication>(value: authentication),
        Provider<CardListUsecase>(value: cardListUsecase),
        Provider<NewCardUsecase>(value: newCardUsecase),
        Provider<TextSynthesizationUsecase>(value: textSynthesizationUsecase),
      ],
      child: Application(authentication: authentication),
    ),
  );
}
