import 'package:flutter/material.dart';
import './sign_in_screen.dart';

class SignInRoute extends MaterialPageRoute {
  SignInRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => SignInScreen();
}
