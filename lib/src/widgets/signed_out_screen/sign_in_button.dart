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
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) => ProcessableFancyButton(
        color: SarakaColors.lightRed,
        isProcessing: _isProcessing,
        onPressed: () => _onPressed(context),
        child: Text('Start with Google Account'),
      );

  void _onPressed(BuildContext context) {
    setState(() {
      _isProcessing = true;
    });

    final authentication = Provider.of<AuthenticationBloc>(context);

    authentication.signIn();
  }
}
