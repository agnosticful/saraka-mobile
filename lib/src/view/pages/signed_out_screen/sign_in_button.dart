import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';
import 'package:saraka/constants.dart';
import 'package:saraka/widgets.dart';

class SignInButton extends StatefulWidget {
  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
        builder: (context, authenticationBloc, _) => StreamBuilder<bool>(
              stream: authenticationBloc.isSigningIn,
              initialData: authenticationBloc.isSigningIn.value,
              builder: (context, snapshot) => ProcessableFancyButton(
                    color: SarakaColor.lightRed,
                    isProcessing: snapshot.requireData,
                    onPressed: () => _onPressed(context),
                    child: Text('Start with Google Account'),
                  ),
            ),
      );

  void _onPressed(BuildContext context) {
    final authentication = Provider.of<AuthenticationBloc>(context);

    authentication.signIn();
  }
}
