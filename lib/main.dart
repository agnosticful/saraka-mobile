import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:saraka/domains.dart';
import 'package:saraka/services.dart';
import 'package:saraka/usecases.dart';
import './application.dart';

void main() {
  final authenticationUsecase = AuthenticationUsecase(
    authenticationService: FirebaseAuthenticationService(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    ),
  );

  final newCardUsecase = NewCardUsecase(
    dataPersistentService: ApplicationStorageService(),
    externalFunctionService: FirebaseFunctionService(),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<Authentication>(value: authenticationUsecase()),
        Provider<NewCardUsecase>(value: newCardUsecase),
      ],
      child: Application(),
    ),
  );
}
