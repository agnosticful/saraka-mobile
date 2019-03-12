import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/blocs.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        onPressed: () => _onPressed(context),
        child: Text('Sign in with Google'),
      );

  void _onPressed(BuildContext context) {
    final authentication = Provider.of<AuthenticationBloc>(context);

    authentication.signIn();
  }
}
