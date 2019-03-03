import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saraka/domains.dart';

class SignInButton extends StatelessWidget {
  final Widget child;

  SignInButton({Key key, this.child}) : super(key: key);

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
    final authentication = Provider.of<Authentication>(context);

    authentication.signIn();
  }
}
