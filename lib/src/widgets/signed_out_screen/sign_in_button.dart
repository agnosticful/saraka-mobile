import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../processable_fancy_button.dart';
import '../../blocs/authentication_bloc.dart';

class SignInButton extends StatefulWidget {
  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
        builder: (context, authenticationBloc) => StreamBuilder<bool>(
              stream: authenticationBloc.isSigningIn,
              initialData: authenticationBloc.isSigningIn.value,
              builder: (context, snapshot) => ProcessableFancyButton(
                    color: SarakaColors.lightRed,
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
