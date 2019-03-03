import 'package:flutter/material.dart';
import './home_screen.dart';

class HomeRoute extends MaterialPageRoute {
  HomeRoute({RouteSettings settings})
      : super(builder: _builder, settings: settings);

  static Widget _builder(BuildContext context) => HomeScreen();
}
